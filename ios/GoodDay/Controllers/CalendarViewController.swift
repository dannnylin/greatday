//
//  CalendarViewController.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    private weak var calendar: FSCalendar!
    private var tableView: UITableView!
    var dataSource: [Activity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func loadView() {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 85, width: self.view.bounds.width, height: height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        self.view.addSubview(calendar)
        self.calendar = calendar
        
        tableView = UITableView(frame: CGRect(x: 0, y: 385, width: 400, height: self.view.frame.height - 385))
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FSCalendar"
        self.tableView.backgroundColor = UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dataSource.removeAll()
        let dateString = date.description
        var dateComponents = dateString.components(separatedBy: " ")
        let data = [
            "date": dateComponents[0]
        ]
        DataService.instance.getInfoForDate(data: data) { (data) in
            let dictionaryData: [String: Any]! = data.dictionaryObject
            let activities = dictionaryData["activities"] as! [String: Any]
            let morningActivities = activities["morning"] as! [[String: Any]]
            let afternoonActivities = activities["afternoon"] as! [[String: Any]]
            let eveningActivities = activities["evening"] as! [[String: Any]]
            
            for activity in morningActivities {
                let newActivity = Activity()
                newActivity.name = activity["name"] as? String
                newActivity.date = activity["date"] as? String
                newActivity.timeOfDay = activity["time_of_day"] as? String
                newActivity.mood = Mood(rawValue: activity["mood"] as! String)
                self.dataSource.append(newActivity)
            }
            
            for activity in afternoonActivities {
                let newActivity = Activity()
                newActivity.name = activity["name"] as? String
                newActivity.date = activity["date"] as? String
                newActivity.timeOfDay = activity["time_of_day"] as? String
                newActivity.mood = Mood(rawValue: activity["mood"] as! String)
                self.dataSource.append(newActivity)
            }
            
            for activity in eveningActivities {
                let newActivity = Activity()
                newActivity.name = activity["name"] as? String
                newActivity.date = activity["date"] as? String
                newActivity.timeOfDay = activity["time_of_day"] as? String
                newActivity.mood = Mood(rawValue: activity["mood"] as! String)
                self.dataSource.append(newActivity)
            }
        }
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    class func create() -> CalendarViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "calendarViewController") as! CalendarViewController
        
        let _ = controller.view
        
        return controller
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
