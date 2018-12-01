//
//  SignUpViewController.swift
//  Habits
//
//  Created by Perry Trinh on 11/6/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailText.text else { return }
        guard let username = usernameText.text else { return }
        guard let password = passwordText.text else { return }
        guard let passwordConfirm = passwordConfirmText.text else { return }
        
        if email == "" || username == "" || password == "" || passwordConfirm == "" {
            let alertController = UIAlertController(title: "Incomplete form", message: "Please fill out all fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    // Update username, notify user, and perform segue
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges {(error) in
                        print("Could not change display name")
                    }
                    
                    let alertController = UIAlertController(title: "Success!", message: "Your account has been created", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        self.performSegue(withIdentifier: "fromSignupToHome", sender: self)
                    }
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else if password != passwordConfirm  {
                    let alertController = UIAlertController(title: "Verification Error.", message: "The two passwords do not match.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.passwordConfirmText.textColor = UIColor.red
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Sign Up Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
