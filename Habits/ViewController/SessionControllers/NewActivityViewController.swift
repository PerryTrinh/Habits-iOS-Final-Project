//
//  NewActivityViewController.swift
//  Habits
//
//  Created by Perry Trinh on 11/30/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class NewActivityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var nameText: UITextField!
    
    // Tag = 1
    @IBOutlet weak var numPicker: UIPickerView!
    
    // Tag = 2
    @IBOutlet weak var unitPicker: UIPickerView!
    
    var numPickerOptions: [Int] = Array(1...60)
    var unitPickerOptions: [String] = ["seconds", "minutes", "hours"]
    var numPickerSelected: Int = 1
    var unitPickerSelected: String = "seconds"
    var relevantSession: Sessions? = nil
    let currentUser = CurrentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let real = self.relevantSession {
            print("YAY NEW ACTIVITY GOT DATA")
            print("Name: \(real.name)")
        } else {
            print("NEW ACTIVITY GOT NO DATA")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return String(self.numPickerOptions[row])
        } else {
            return self.unitPickerOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return self.numPickerOptions.count
        } else {
            return self.unitPickerOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.numPickerSelected = self.numPickerOptions[row]
        } else {
            self.unitPickerSelected = self.unitPickerOptions[row]
        }
    }
    
    @IBAction func createPressed(_ sender: Any) {
        guard let activityName = nameText.text else { return }
        if activityName == "" {
            let alertController = UIAlertController(title: "Incomplete", message: "No name set.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.currentUser.addSessionActivity(session: self.relevantSession!, activity: Activities(name: activityName, numTimeInterval: self.numPickerSelected, unitTimeInterval: self.unitPickerSelected, enabled: true))
            
            let alertController = UIAlertController(title: "Success!", message: "Reminder added to \(self.relevantSession!.name) Added", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                self.performSegue(withIdentifier: "unwindSegueToExpandedSessionView", sender: self)
            }
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
