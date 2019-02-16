//
//  ActivityViewCell.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit

class ActivityViewCell: UITableViewCell {
    var activity: Activity! {
        didSet {
            activityNameLabel.text = activity.name
            if (activity.mood.description == "sad") {
                moodIndicatorView.backgroundColor = UIColor(red:0.00, green:0.56, blue:1.00, alpha:1.0)
            } else if (activity.mood.description == "meh") {
                moodIndicatorView.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.70, alpha:1.0)
            } else {
                moodIndicatorView.backgroundColor = UIColor(red:1.00, green:0.87, blue:0.00, alpha:1.0)
            }
        }
    }
    let activityNameLabel =  UILabel()
    let moodIndicatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        activityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        moodIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(activityNameLabel)
        contentView.addSubview(moodIndicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityNameLabel.frame = CGRect(x: 20, y: 5, width: 150, height: 30)
        moodIndicatorView.frame = CGRect(x: 340, y: 7, width: 20, height: 20)
        moodIndicatorView.layer.cornerRadius = moodIndicatorView.bounds.size.width/2
        moodIndicatorView.layer.masksToBounds = true
    }
}
