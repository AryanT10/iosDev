//
//  StartViewController.swift
//  ToDoList
//
//  Created by Aryan Tuwar on 2024-08-01.
//

// StartViewController represents the starting screen for this app.
//  Users can sign in with their username and only load the reminders
//  for the given user.

import UIKit

class StartViewController: UIViewController {

    // Username field
    @IBOutlet weak var usernameTextField: UITextField!
    // Sign in button
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUsernameField()
    }
    
    // Disables sign in button if username is empty
    func checkUsernameField() {
        if let username = usernameTextField.text {
            signInBtn.isEnabled = !username.isEmpty
        } else {
            signInBtn.isEnabled = false
        }
    }
    
    // Watches username textField change
    @IBAction func usernameEdit() {
        checkUsernameField()
    }
    
    // Unwind
    @IBAction func unwindToStart(_ unwindSegue: UIStoryboardSegue) {}
    

    // Set username in RemindersViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RemindersViewController
        
        if let username = usernameTextField.text{
            destination.currentUser = username
        }
    }

}
