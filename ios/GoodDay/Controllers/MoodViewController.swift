//
//  MoodViewController.swift
//  GoodDay
//
//  Created by Danny on 2/15/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import UIKit

class MoodViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var sadButton: MoodButton!
    @IBOutlet weak var mehButton: MoodButton!
    @IBOutlet weak var happyButton: MoodButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtons()
    }
    
    func setUpButtons() {
        sadButton.mood = Mood.sad
        mehButton.mood = Mood.meh
        happyButton.mood = Mood.happy
    }
    
    class func create() -> MoodViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "moodViewController") as! MoodViewController
        return controller
    }
    
    @IBAction func skipPressed(sender: UIButton) {
        let mainNavController = MainTabBarController.create()
        UIApplication.shared.keyWindow?.rootViewController = mainNavController
    }
}
