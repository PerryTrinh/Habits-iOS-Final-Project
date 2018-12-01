//
//  NewSessionViewController.swift
//  Habits
//
//  Created by Perry Trinh on 11/30/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class NewSessionViewController: UIViewController {
    let currentUser = CurrentUser()
    
    @IBOutlet weak var nameText: UITextField!
    @IBAction func createPressed(_ sender: Any) {
        guard let sessionName = nameText.text else { return }
        if sessionName == "" {
            let alertController = UIAlertController(title: "Incomplete", message: "No name set.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            currentUser.addNewSession(toAdd: Sessions(name: sessionName, enabled: false))
            
            let alertController = UIAlertController(title: "Success!", message: "Session Added", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                self.performSegue(withIdentifier: "unwindSegueToSessionView", sender: self)
            }
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
