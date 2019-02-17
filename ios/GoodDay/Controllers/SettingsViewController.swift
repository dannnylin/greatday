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

class SettingsViewController: UIViewController {
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.getMoodCounts { (data) in
            if let moodData = data.dictionaryObject as? [String: Int] {
                self.setupPieChart(data: moodData)
            }
        }
    }
    
    class func create() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
        return controller
    }
    
    func setupPieChart(data: [String: Int]) {
        pieChart.chartDescription?.enabled = false
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
        //pieView.rotationEnabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.legend.horizontalAlignment = Legend.HorizontalAlignment.center
        
        var entries: [PieChartDataEntry] = Array()
        for (mood, count) in data {
            if (mood == "happy") {
                entries.append(PieChartDataEntry(value: Double(count), label: mood))
            }
        }
        for (mood, count) in data {
            if (mood == "meh") {
                entries.append(PieChartDataEntry(value: Double(count), label: mood))
            }
        }
        for (mood, count) in data {
            if (mood == "sad") {
                entries.append(PieChartDataEntry(value: Double(count), label: mood))
            }
        }
        let dataSet = PieChartDataSet(values: entries, label: "")
        
        let c1 = NSUIColor(hex: 0xfede00) //happy
        let c2 = NSUIColor(hex: 0xb4b4b3) //meh
        let c3 = NSUIColor(hex: 0x008ffe) //sad
        
        dataSet.colors = [c1, c2, c3]
        dataSet.drawValuesEnabled = false
        
        pieChart.data = PieChartData(dataSet: dataSet)
    }
    
    
}
