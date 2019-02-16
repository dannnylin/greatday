//
//  AddActivityViewController.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit

class AddActivityViewController: UIViewController {
    
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timeOfDaySegmentedControl: UISegmentedControl!
    var parentController: ActivitiesViewController!
    var date: String!
    var mood: Mood!
    var timeOfDay: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closePressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(sender: UIButton) {
        let data: [String: Any] = [
            "activity": activityTextField.text!,
            "mood": mood.description,
            "date": date,
            "timeOfDay": timeOfDay
        ]
        DataService.instance.addActivity(data: data)
        parentController.dataSource.append(data)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moodIndexChanged(sender: Any) {
        switch moodSegmentedControl.selectedSegmentIndex {
        case 0:
            mood = Mood.sad
        case 1:
            mood = Mood.meh
        case 2:
            mood = Mood.happy
        default:
            break
        }
    }
    
    @IBAction func timeOfDayChanged(sender: Any) {
        switch timeOfDaySegmentedControl.selectedSegmentIndex {
        case 0:
            timeOfDay = "morning"
        case 1:
            timeOfDay = "afternoon"
        case 2:
            timeOfDay = "evening"
        default:
            break
        }
    }
    
    class func create(date: String) -> AddActivityViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "addActivityViewController") as! AddActivityViewController
        
        controller.date = date
        
        return controller
    }
}
