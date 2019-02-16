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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside  )
        
    }
    
    @objc func buttonClicked() {
        if let mood = mood {
            DataService.instance.addMoodToDate(mood: mood)
        }
    }
}
