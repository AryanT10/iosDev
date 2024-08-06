//
//  AddEditTableViewController.swift
//  ToDoList
//
//  Created by Aryan Tuwar on 2024-07-31.
//

import UIKit

// AddEditTableViewController represents the form for creating or editing a Reminder

class AddEditTableViewController: UITableViewController {
    
    // Current reminder and user
    var reminder: Reminder?
    var currentUser: String?

    // Input fields
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    // Save button
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIButton!
    
    // Constructors
    required init?(coder: NSCoder, reminder: Reminder?, currentUser: String?) {
        super.init(coder: coder)
        self.reminder = reminder
        self.currentUser = currentUser
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let reminder = reminder {
            // Fill fields if editing existing
            titleTextField.text = reminder.title
            descriptionTextField.text = reminder.description
            datePicker.date = reminder.dueDate
            imageView.image = reminder.image
            title = "Edit Reminder"
        } else {
            shareBtn.isEnabled = false
            title = "New Reminder"
        }
    }
    
    // Open photo library for user to select image
    @IBAction func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // Share reminder to other applications
    @IBAction func shareReminder() {
        guard let reminder = reminder else { return }
                
        // Items included in share
        var itemsToShare: [Any] = [reminder.title, reminder.description ?? ""]
        
        // Include image
        if let image = reminder.image {
            itemsToShare.append(image)
        }
        
        // Open share view
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Conditional segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let btn = sender as? UIBarButtonItem else { return false }
        
        // Segue on cancel
        if let title = btn.title {
            if title == "Done" {
                return true
            }
        }

        // Shake titleTextField if empty title
        if let text = titleTextField.text {
            if !text.isEmpty {
                // else, save and segue
                saveReminder()
                return true
            }
        }
        titleTextField.shake()
        return false
        
    }
    
    
    // Save form data to current reminder
    func saveReminder() {
        // Get reminder fields
        let title = titleTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let dueDate = Calendar.current.startOfDay(for: datePicker.date) 
        let image = imageView.image
        let username = currentUser ?? ""
        
        if let reminder = reminder {
            // Update existing reminder
            reminder.updateReminder(title: title, description: description, dueDate: dueDate, image: image, username: username)
        } else {
            // Create new reminder
            let newReminder = Reminder(title: title, description: description, dueDate: dueDate, image: image, username: username)
            reminder = newReminder
        }
    }
}

// For image selection delegation
extension AddEditTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// UI/UX Feature: Shake text field if required but is empty
extension UIView {
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 5
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 3, y: self.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 3, y: self.center.y))
        self.layer.add(shakeAnimation, forKey: "position")
    }
}
