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
    var dataSource : [(name: String, count: Int)] = [(String, Int)]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HappiestActivitiesCell.self, forCellReuseIdentifier: "happiestCell")
        
        DataService.instance.getStats { (data) in
            if let resultsDict = data.dictionaryObject as? [String: Int] {
                var sortedDict = resultsDict.sorted{ $0.1 > $1.1 }
                var currentCount = 0
                for (activity, count) in sortedDict {
                    if (currentCount >= 5) {
                        break
                    }
                    self.dataSource.append((activity, count))
                    currentCount += 1
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "happiestCell") as? HappiestActivitiesCell else {
            return UITableViewCell()
        }
        let cellData = dataSource[indexPath.row]
        cell.selectionStyle = .none
        cell.activityNameLabel.text = "\(cellData.name) - \(cellData.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Happiest Activities"
    }
}
