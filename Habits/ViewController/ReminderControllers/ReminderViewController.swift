//
//  ReminderViewController.swift
//  Habits
//
//  Created by Perry Trinh on 11/6/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let reminderList = ReminderList()
    let currentUser = CurrentUser()
    @IBOutlet weak var reminderTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderList.getSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reminderTableView.dequeueReusableCell(withIdentifier: "reminderCell") as! ReminderCell
        let index = indexPath.row
        let relevantReminder = reminderList.getReminder(at: index)
        cell.nameLabel.text = relevantReminder.getName()
        cell.descriptionLabel.text = relevantReminder.getDescription()
        cell.timeLabel.text = relevantReminder.getReadableDateString()
        cell.reminderSwitch.isOn = relevantReminder.enabled
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderTableView.dataSource = self
        reminderTableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(segueToNewReminder))
        print("VIEW LOADED")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEW WILL APPEAR")
        currentUser.getAllReminders(completion: { (reminderList) in
            for reminder in reminderList {
                self.reminderList.add(reminder: reminder)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEW DID APPEAR IN REMINDER VC")
        self.reminderList.printAllReminders()
        self.reminderTableView.reloadData()
    }
    
    @IBAction func unwindToReminderView(segue:UIStoryboardSegue) { }
    
    @objc func segueToNewReminder() {
        self.performSegue(withIdentifier: "createNewReminder", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
