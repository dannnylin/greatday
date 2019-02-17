//
//  StatsViewController.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit
import Charts

class StatsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private weak var footerView: UIView!
    private var pieChart: PieChartView!
    var dataSource: [[(name: String, count: Int)]] = [[(String, Int)]]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HappiestActivitiesCell.self, forCellReuseIdentifier: "happiestCell")
        tableView.register(ActivityViewCell.self, forCellReuseIdentifier: "cell")
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 475))
        customView.backgroundColor = UIColor.white
        pieChart = PieChartView(frame: CGRect(x: -15, y: 40, width: 400, height: 400))
        let titleLabel = UILabel(frame: CGRect(x: 133, y: 10, width: 200, height: 25))
        titleLabel.textColor = UIColor.black
        titleLabel.text = "Mood Counts"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        customView.addSubview(pieChart)
        customView.addSubview(titleLabel)
        tableView.tableFooterView = customView
        
        DataService.instance.getRecommendedActivities { (data) in
            var modifiedDataSource: [(String, Int)] = [(String, Int)]()
            if let recommendedActivities = data.arrayObject as? [String] {
                for activity in recommendedActivities {
                    modifiedDataSource.append((activity, 0))
                }
            }
            self.dataSource.append(modifiedDataSource)
            
            DataService.instance.getStats { (data) in
                let happyActivities = data.dictionaryObject?["happy"] as? [String: Int]
                let sadActivities = data.dictionaryObject?["sad"] as? [String: Int]
                if let happyDict = happyActivities {
                    self.dataSource.append([])
                    let sortedDict = happyDict.sorted{ $0.1 > $1.1 }
                    var currentCount = 0
                    for (activity, count) in sortedDict {
                        if (currentCount >= 5) {
                            break
                        }
                        self.dataSource[1].append((activity, count))
                        currentCount += 1
                    }
                }
                
                if let sadDict = sadActivities {
                    self.dataSource.append([])
                    let sortedDict = sadDict.sorted{ $0.1 > $1.1 }
                    var currentCount = 0
                    for (activity, count) in sortedDict {
                        if (currentCount >= 5) {
                            break
                        }
                        self.dataSource[2].append((activity, count))
                        currentCount += 1
                    }
                }
            }
        }
        
        DataService.instance.getMoodCounts { (data) in
            if let moodData = data.dictionaryObject as? [String: Int] {
                self.setupPieChart(data: moodData)
            }
        }
    }
    
    func setupPieChart(data: [String: Int]) {
        pieChart.chartDescription?.enabled = false
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
        //pieView.rotationEnabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.legend.horizontalAlignment = Legend.HorizontalAlignment.center
        
        var entries: [PieChartDataEntry] = Array()
        for (mood, count) in data {
            if (mood == "happy") {
                entries.append(PieChartDataEntry(value: Double(count), label: mood))
            }
        }
        for (mood, count) in data {
            if (mood == "meh") {
                entries.append(PieChartDataEntry(value: Double(count), label: mood))
            }
        }
        for (mood, count) in data {
            if (mood == "sad") {
                entries.append(PieChartDataEntry(value: Double(count), label: mood))
            }
        }
        let dataSet = PieChartDataSet(values: entries, label: "")
        
        let c1 = NSUIColor(hex: 0xfede00) //happy
        let c2 = NSUIColor(hex: 0xb4b4b3) //meh
        let c3 = NSUIColor(hex: 0x008ffe) //sad
        
        dataSet.colors = [c1, c2, c3]
        dataSet.drawValuesEnabled = false
        
        pieChart.data = PieChartData(dataSet: dataSet)
    }
    
    class func create() -> StatsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "statsViewController") as! StatsViewController
        
        let _ = controller.view
        
        return controller
    }
}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ActivityViewCell else {
                return UITableViewCell()
            }
            let cellData = dataSource[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            let newActivity = Activity()
            newActivity.name = cellData.name
            newActivity.mood = Mood.happy
            cell.activity = newActivity
            cell.activityNameLabel.text = "\(cellData.name)"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "happiestCell") as? HappiestActivitiesCell else {
                return UITableViewCell()
            }
            let cellData = dataSource[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            cell.activityNameLabel.text = "\(cellData.name) - \(cellData.count)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Recommended Activities"
        } else if (section == 1) {
            return "Happiest Activities"
        } else {
            return "Saddest Activities"
        }
    }
}
