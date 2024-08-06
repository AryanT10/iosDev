//
//  ReminderTableViewCell.swift
//  ToDoList
//
//  Created by Aryan Tuwar on 2024-08-01.
//

// ReminderTableViewCell represents a custom Reminder tableView cell

import UIKit

protocol ReminderTableViewCellDelegate {
    func didToggleCompletion(for reminder: Reminder)
}

class ReminderTableViewCell: UITableViewCell {
    
    // Delegate that can modify tableView
    var delegate: ReminderTableViewCellDelegate?
    // Reminder for cell
    var reminder: Reminder?
    
    // Cell ui elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var btn: UIButton! // button to toggle completion
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
        super.setSelected(selected, animated: false)
    }
    
    // Configure cell for reminder
    func config(with reminder: Reminder) {
        self.reminder = reminder
        
        titleLabel.text = reminder.title
        subtitleLabel.text = reminder.description
        
        // Set background and cell icon depending on completion state
        if reminder.isCompleted {
            self.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            self.backgroundColor = .systemGray6
        } else {
            self.imageView?.image = UIImage(systemName: "circle")
        }
        
        selectionStyle = .none
    }
    
    
    // Delegate handles completion button press
    @IBAction func toggleCompletion(_ sender: Any) {
        guard let reminder = reminder else { return }
        selectionStyle = .none
        delegate?.didToggleCompletion(for: reminder)
    }
}
