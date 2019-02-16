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
    var statsViewController: UIViewController!
    var moodViewController: MoodViewController!
    var settingsViewController: UIViewController!
    var calendarViewController: UIViewController!
    
    var navigationControllers: [UINavigationController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewControllers()
        setupNavigationControllers()
        
        self.viewControllers = navigationControllers
        self.tabBar.tintColor = UIColor.blue
    }
    
    func createViewControllers() {
        homeViewController = UIViewController()
        homeViewController.view.backgroundColor = UIColor.white
        homeViewController.navigationItem.title = "HOME"
        
        statsViewController = UIViewController()
        statsViewController.view.backgroundColor = UIColor.white
        statsViewController.navigationItem.title = "STATS"
        
        moodViewController = MoodViewController.create()
        moodViewController.view.backgroundColor = UIColor.white
        moodViewController.navigationItem.title = "+"
        
        statsViewController = UIViewController()
        statsViewController.view.backgroundColor = UIColor.white
        statsViewController.navigationItem.title = "STATS"
        
        calendarViewController = UIViewController()
        calendarViewController.view.backgroundColor = UIColor.white
        calendarViewController.navigationItem.title = "CALENDAR"
        
        settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = UIColor.white
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
        
        moodNavigationController.tabBarItem.title = "+"
        
        calendarNavigationController.tabBarItem.title = "CALENDAR"
        
        settingsNavigationController.tabBarItem.title = "SETTINGS"
        
        navigationControllers = [homeNavigationController, statsNavigationController, moodNavigationController, calendarNavigationController, settingsNavigationController]
    }
    
    class func create() -> MainTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mainTabBarController") as! MainTabBarController
        
        
        let _ = controller.view
        
        return controller
    }
    
}
