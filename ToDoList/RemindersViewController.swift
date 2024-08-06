//
//  RemindersViewController.swift
//  ToDoList
//
//  Created by Aryan Tuwar on 2024-08-01.
//

import UIKit

class RemindersViewController: UIViewController, ReminderTableViewCellDelegate {

    // Table view
    @IBOutlet weak var tableView: UITableView!
    
    // Current username
    var currentUser: String = "ExampleUser123"
    
    // Reminders
    var reminders: [Reminder] = [] // all reminders
    var remindersMap: [Date: [Reminder]] = [:] // sorted by date
    var completedReminders: [Reminder] = [] // completed
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = currentUser
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Load persisted date
        reminders = Reminder.loadReminders(for: currentUser)

        updateReminderMap()
    }
    

    // Build Reminder dictionary sorted by date and completed reminders array
    func updateReminderMap() {
        // Empty reminders
        remindersMap.removeAll()
        completedReminders.removeAll()
        
        for reminder in reminders {
            // Complete reminder
            if reminder.isCompleted {
                completedReminders.append(reminder)
                continue
            }
            
            // Incomplete reminder
            let date = reminder.dueDate
            
            if remindersMap[date] == nil {
                // Create array for new key
                remindersMap[date] = [reminder]
            } else {
                // Append to existing key
                remindersMap[date]?.append(reminder)
            }
        }
    }
    
    // Get date from given section
    func getSectionDate(section: Int) -> Date {
        let dates = Array(remindersMap.keys).sorted()
        return dates[section]
    }
    
    // Returns int value of table's completed section
    // Completed section will be last section index (or just number of keys due to its count starting at 1)
    func getCompletedSection() -> Int {
        return remindersMap.keys.count
    }

    // MARK: - Table View
    
    // Toggle tableView editing mode
    @IBAction func toggleEdit() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }
    
    // MARK: Utils
    
    // Return Date with an offset of n days
    func fromToday(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to:  Calendar.current.startOfDay(for: Date()))!
    }
    
    // Handles completing a Reminder, called from ReminderTableViewCell delegate
    func didToggleCompletion(for reminder: Reminder) {
        reminder.toggleCompletion()
        updateReminderMap()
        tableView.reloadData()
        Reminder.saveReminders(reminders, for: currentUser)
    }
    
    // MARK: Navigation
    
    // Segue to add / edit view controller
    @IBSegueAction func goToAddEdit(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> AddEditTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPathOfSelectedCell = tableView.indexPath(for: cell) {
            if indexPathOfSelectedCell.section == getCompletedSection() {
                // Edit completed cell
                let reminder = completedReminders[indexPathOfSelectedCell.row]
                return AddEditTableViewController(coder: coder, reminder: reminder, currentUser: currentUser)
            } else {
                // Edit incompleted cell
                let date = getSectionDate(section: indexPathOfSelectedCell.section)
                if let reminder = remindersMap[date]?[indexPathOfSelectedCell.row] {
                    return AddEditTableViewController(coder: coder, reminder: reminder, currentUser: currentUser)
                }
            }
        }
        // Create new reminder
        return AddEditTableViewController(coder: coder, reminder: nil, currentUser: currentUser)
    }
    
    // Save reminder when finished adding / editing
    @IBAction func unwindToRemindersTableViewController(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? AddEditTableViewController, let reminder = sourceVC.reminder {
            
            // Append to reminders if Reminder did not exist
            if !Reminder.reminderExists(reminder, in: reminders) {
                reminders.append(reminder)
            }
            updateReminderMap()
       }
        tableView.reloadData()
        Reminder.saveReminders(reminders, for: currentUser)
    }
}


// MARK: Table View Methods

extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections to number of date keys + completed section
    func numberOfSections(in tableView: UITableView) -> Int {
        return remindersMap.keys.count + (completedReminders.isEmpty ? 0 : 1)
    }

    // Set number of section rows to number of reminders for each date
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == getCompletedSection() {
            // Return completed reminder count
            return completedReminders.count
        } else {
            // Return incompleted reminders for a date count
            let date = getSectionDate(section: section)
            return remindersMap[date]?.count ?? 0
        }
    }
    
    // Name sections by date
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == getCompletedSection() {
            // Completed section
            return "Completed"
        } else {
            // Dates for incompleted sections
            let date = getSectionDate(section: section)
            
            if Calendar.current.isDateInToday(date) {
                return "Today"
            } else if Calendar.current.isDateInTomorrow(date) {
                return "Tomorrow"
            } else if Calendar.current.isDateInYesterday(date) {
                return "Yesterday"
            }
            else {
                return Reminder.formatDate(date)
                
            }
        }
    }
    
    // Configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReminderTableViewCell
        
        cell.delegate = self // Allows current view contoller to handle completion toggle instead of passing all the arrays/dicts
        
        if indexPath.section == getCompletedSection() {
            // Configure completed cells
            let reminder = completedReminders[indexPath.row]
            cell.config(with: reminder)
        } else {
            // Configure incompleted cells
            let date = getSectionDate(section: indexPath.section)
            if let reminder = remindersMap[date]?[indexPath.row]  {
                cell.config(with: reminder)
            }
        }
        return cell
    }
    
    // Handle deleting table row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            if indexPath.section == getCompletedSection() {
                // Delete completed reminder
                let removedReminder = completedReminders.remove(at: indexPath.row)
                Reminder.deleteReminder(removedReminder, from: &reminders)
                
                if completedReminders.isEmpty {
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } else {
                // Delete incomplete reminder
                let date = getSectionDate(section: indexPath.section)
                if var remindersForDate = remindersMap[date] {
                    let removedReminder = remindersForDate.remove(at: indexPath.row)
                    Reminder.deleteReminder(removedReminder, from: &reminders)

                    if remindersForDate.isEmpty {
                        remindersMap.removeValue(forKey: date)
                        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                    } else {
                        remindersMap[date] = remindersForDate
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
            
            updateReminderMap()
            tableView.endUpdates()
            Reminder.saveReminders(reminders, for: currentUser)
        }
    }


    // This took like 1 hour, sometimes works. Forgive me.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if fromIndexPath.section == getCompletedSection() {
            let movedReminder = completedReminders.remove(at: fromIndexPath.row)
            if to.section == getCompletedSection() {
                completedReminders.insert(movedReminder, at: to.row)
            } else {
                let date = getSectionDate(section: to.section)
                movedReminder.dueDate = date
                movedReminder.isCompleted = false
                if var remindersForDate = remindersMap[date] {
                    remindersForDate.insert(movedReminder, at: to.row)
                    remindersMap[date] = remindersForDate
                } else {
                    remindersMap[date] = [movedReminder]
                }
            }
        } else {
            let date = getSectionDate(section: fromIndexPath.section)
            if var remindersForDate = remindersMap[date] {
                let movedReminder = remindersForDate.remove(at: fromIndexPath.row)
                if remindersForDate.isEmpty {
                    remindersMap.removeValue(forKey: date)
                } else {
                    remindersMap[date] = remindersForDate
                }
                
                if to.section == getCompletedSection() {
                    movedReminder.isCompleted = true
                    completedReminders.insert(movedReminder, at: to.row)
                } else {
                    let newDate = getSectionDate(section: to.section)
                    movedReminder.dueDate = newDate
                    if var remindersForNewDate = remindersMap[newDate] {
                        remindersForNewDate.insert(movedReminder, at: to.row)
                        remindersMap[newDate] = remindersForNewDate
                    } else {
                        remindersMap[newDate] = [movedReminder]
                    }
                }
            }
        }
        
        updateReminderMap()
        tableView.reloadData()
        Reminder.saveReminders(reminders, for: currentUser)
        
    }
    

    
    // Set conditional rearranging of the table view
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
