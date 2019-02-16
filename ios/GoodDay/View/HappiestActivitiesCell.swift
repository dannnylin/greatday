//
//  HappiestActivitiesCell.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit

class HappiestActivitiesCell: UITableViewCell {
    var name: String!
    var count: Int!
    
    let activityNameLabel =  UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        activityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityNameLabel.frame = CGRect(x: 20, y: 5, width: 150, height: 30)
    }
}
