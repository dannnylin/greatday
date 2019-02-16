//
//  MainTabBarController.swift
//  GoodDay
//
//  Created by Danny on 2/15/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import UIKit
import Foundation

class MainTabBarController: UITabBarController {
    var homeViewController: UIViewController!
    var statsViewController: StatsViewController!
    var moodViewController: MoodViewController!
    var settingsViewController: UIViewController!
    var calendarViewController: CalendarViewController!
    
    var navigationControllers: [UINavigationController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewControllers()
        setupNavigationControllers()
        
        self.viewControllers = navigationControllers
        self.tabBar.tintColor = UIColor(red:0.00, green:0.56, blue:1.00, alpha:1.0)
    }
    
    func createViewControllers() {
        homeViewController = UIViewController()
        homeViewController.view.backgroundColor = UIColor.white
        homeViewController.navigationItem.title = "HOME"
        
        statsViewController = StatsViewController.create()
        statsViewController.view.backgroundColor = UIColor.white
        statsViewController.tabBarItem.image = UIImage(named: "stats-icon")
        statsViewController.navigationItem.title = "STATS"
        
        moodViewController = MoodViewController.create()
        moodViewController.view.backgroundColor = UIColor.white
        moodViewController.tabBarItem.image = UIImage(named: "plus-icon")
        moodViewController.navigationItem.title = "+"
        
        calendarViewController = CalendarViewController.create()
        calendarViewController.view.backgroundColor = UIColor.white
        calendarViewController.tabBarItem.image = UIImage(named: "calendar-icon")
        calendarViewController.navigationItem.title = "CALENDAR"
        
        settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = UIColor.white
        settingsViewController.tabBarItem.image = UIImage(named: "settings-icon")
        settingsViewController.navigationItem.title = "SETTINGS"
    }
    
    func setupNavigationControllers() {
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let statsNavigationController = UINavigationController(rootViewController: statsViewController)
        let moodNavigationController = UINavigationController(rootViewController: moodViewController)
        let calendarNavigationController = UINavigationController(rootViewController: calendarViewController)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        
        homeNavigationController.tabBarItem.title = "HOME"
        
        statsNavigationController.tabBarItem.title = "STATS"
        
        moodNavigationController.tabBarItem.title = "ADD"
        
        calendarNavigationController.tabBarItem.title = "CALENDAR"
        
        settingsNavigationController.tabBarItem.title = "SETTINGS"
        
        navigationControllers = [statsNavigationController, moodNavigationController, calendarNavigationController, settingsNavigationController]
    }
    
    class func create() -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBarController") as! MainTabBarController
        
        
        let _ = controller.view
        
        return controller
    }
    
}
