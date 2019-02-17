//
//  StatsViewController.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [[(name: String, count: Int)]] = [[(String, Int)]]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HappiestActivitiesCell.self, forCellReuseIdentifier: "happiestCell")
        tableView.register(ActivityViewCell.self, forCellReuseIdentifier: "cell")
        
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
