//
//  SettingsViewController.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit
import Charts

enum SettingsOptions: String {
    case Share = "Share the App"
    case Rate = "Rate Us"
    case Backup = "Back Up Data"
    case Visualize = "Visualize Data"
    case HelpFAQ = "Help & FAQ"
    case Contact = "Contact Us"
    
    var description: String {
        return self.rawValue
    }
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [[SettingsOptions]] = [[.Backup, .Visualize], [.Share, .Rate], [.HelpFAQ, .Contact]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HappiestActivitiesCell.self, forCellReuseIdentifier: "happiestCell")
    }
    
    class func create() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
        return controller
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "happiestCell") as? HappiestActivitiesCell else {
            return UITableViewCell()
        }
        let cellData = dataSource[indexPath.section][indexPath.row]
        cell.activityNameLabel.text = cellData.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Data Management"
        } else if (section == 1) {
            return "Sharing"
        } else {
            return "Support"
        }
    }
}
