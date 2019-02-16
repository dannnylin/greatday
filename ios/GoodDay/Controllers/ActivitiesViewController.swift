//
//  ActivitiesViewController.swift
//  GoodDay
//
//  Created by Danny on 2/16/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {
    var date: String!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [Activity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ActivityViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPressed(sender: UIBarButtonItem) {
        let addActivityViewController = AddActivityViewController.create(date: date)
        addActivityViewController.parentController = self
        self.present(addActivityViewController, animated: true, completion: nil)
    }
    
    class func create() -> ActivitiesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "activitiesViewController") as! ActivitiesViewController
        return controller
    }
}

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ActivityViewCell else {
            return UITableViewCell()
        }
        let cellData = dataSource[indexPath.row]
        cell.activity = cellData
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
