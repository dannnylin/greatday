//
//  MoodButton.swift
//  GoodDay
//
//  Created by Danny on 2/15/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import UIKit

enum Mood : String {
    case sad = "sad"
    case meh = "meh"
    case happy = "happy"
    
    var description: String {
        return self.rawValue
    }
}

class MoodButton: UIButton {
    var mood: Mood?
    var date: String?
    var navigationController: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside  )
        
    }
    
    @objc func buttonClicked() {
        if let mood = mood {
            if let date = date {
                DataService.instance.addMoodToDate(mood: mood, date: date)
            } else {
                DataService.instance.addMoodToDate(mood: mood, date: nil)
            }
        }
        let activitiesViewController = ActivitiesViewController.create()
        if (date != nil) {
            activitiesViewController.date = date
        } else {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateTime = Date()
            let dateString = dateFormatter.string(from: dateTime)
            activitiesViewController.date = dateString
        }
        if (navigationController != nil) {
            navigationController?.present(activitiesViewController, animated: true, completion: nil)
        } else {
        UIApplication.shared.keyWindow?.rootViewController?.present(activitiesViewController, animated: true, completion: nil)
        }
    }
}
