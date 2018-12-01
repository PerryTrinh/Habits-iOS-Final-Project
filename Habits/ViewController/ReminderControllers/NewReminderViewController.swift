//
//  NewReminderViewController.swift
//  Habits
//
//  Created by Perry Trinh on 11/26/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class NewReminderViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let currentUser = CurrentUser()
    
    @IBAction func createButtonPressed(_ sender: Any) {
        guard let name = nameText.text else { return }
        guard let description = descriptionText.text else { return }
        let date = datePicker.date
        
        if name == "" {
            let alertController = UIAlertController(title: "Incomplete", message: "No name set.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            print(date)
            print("DATE PRINTED")
            currentUser.addNewReminder(toAdd: Reminders(name: name, description: description, date: date, enabled: true))
            
            // Notify user of success
            let alertController = UIAlertController(title: "Success!", message: "Reminder Added", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                self.performSegue(withIdentifier: "unwindSegueToReminderView", sender: self)
            }
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
