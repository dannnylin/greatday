//
//  MoodButton.swift
//  GoodDay
//
//  Created by Danny on 2/15/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import UIKit

enum Mood {
    case sad
    case meh
    case happy
}

class MoodButton: UIButton {
    var mood: Mood?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside  )
        
    }
    
    @objc func buttonClicked() {
        if let mood = mood {
            print(mood)
        }
    }
}
