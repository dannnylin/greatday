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
    private var lineChart: LineChartView!
    var dataSource: [[(name: String, count: Int)]] = [[(String, Int)]]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HappiestActivitiesCell.self, forCellReuseIdentifier: "happiestCell")
        tableView.register(ActivityViewCell.self, forCellReuseIdentifier: "cell")
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 970))
        customView.backgroundColor = UIColor.white
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 475, width: 400, height: 20))
        separatorView.backgroundColor = NSUIColor(hex: 0xefeff4)
        separatorView.layer.borderWidth = 1
        separatorView.layer.borderColor = (NSUIColor(hex: 0xe8e8e8)).cgColor
        
        pieChart = PieChartView(frame: CGRect(x: -15, y: 40, width: 400, height: 400))
        let pieChartTitleLabel = UILabel(frame: CGRect(x: 133, y: 10, width: 200, height: 25))
        pieChartTitleLabel.textColor = UIColor.black
        pieChartTitleLabel.text = "Mood Counts"
        pieChartTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        customView.addSubview(pieChartTitleLabel)
        customView.addSubview(pieChart)
        customView.addSubview(separatorView)
        
        lineChart = LineChartView(frame: CGRect(x: 13, y: 540, width: 350, height: 400))
        lineChart.chartDescription?.text = "last 10 days"
        let lineChartTitleLabel = UILabel(frame: CGRect(x: 133, y: 500, width: 200, height: 25))
        lineChartTitleLabel.textColor = UIColor.black
        lineChartTitleLabel.text = "Mood History"
        lineChartTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        customView.addSubview(lineChart)
        customView.addSubview(lineChartTitleLabel)
        
        tableView.tableFooterView = customView
        
        loadData()
    }
    
    func loadData() {
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
        
        DataService.instance.getLastFiveDaysStats { (data) in
            if let historicalData = data.arrayObject {
                var data: [ChartDataEntry] = [ChartDataEntry]()
                var dates: [String] = [String]()
                var count = 0
                for day in historicalData {
                    if let dayInfo = day as? Array<Any> {
                        if let date = dayInfo[0] as? String {
                            dates.append(date)
                        }
                        if let moodScore = dayInfo[1] as? Int {
                            data.append(ChartDataEntry(x: Double(count), y: Double(moodScore)))
                        }
                    } else {
                        data.append(ChartDataEntry(x: Double(count), y: 0))
                    }
                    count += 1
                }
                self.setupLineChart(entries: data, dates: dates)
            }
        }
    }
    
    func setupLineChart(entries: [ChartDataEntry], dates: [String]) {
        let line1 = LineChartDataSet(values: entries, label: "Mood")
        line1.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        lineChart.data = data
        print(dates)
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        lineChart.xAxis.granularity = 1
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
