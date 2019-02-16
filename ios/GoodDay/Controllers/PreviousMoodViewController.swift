//
//  PreviousMoodViewController.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import UIKit

class PreviousMoodViewController: MoodViewController {
    
    @IBOutlet weak var datePickerTextView: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateTime = Date()
        let dateString = dateFormatter.string(from: dateTime)
        datePickerTextView.text = dateString
    }
    
    func modifyButtonsDates() {
        sadButton.date = datePickerTextView.text
        mehButton.date = datePickerTextView.text
        happyButton.date = datePickerTextView.text
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        datePickerTextView.inputAccessoryView = toolbar
        datePickerTextView.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datePickerTextView.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        modifyButtonsDates()
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    override class func create() -> PreviousMoodViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "previousMoodViewController") as! PreviousMoodViewController
        return controller
    }
}
