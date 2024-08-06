#  <#Title#>

//
//  RemindersTableViewController.swift
//  ToDoList
//
//  Created by Aryan Tuwar on 2024-07-31.
//

import UIKit

class RemindersTableViewController: UITableViewController {
    
    // Reminders
    var reminders: [Reminder] = []
    
    // Reminders mapped to thier date
    var remindersMap: [Date: [Reminder]] = [:]
    var completedReminders: [Reminder] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sample data
        loadSampleDate()
        
        updateReminderMap()
        title = "Reminders"
        
//        tableView.isEditing = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewReminder))
    }
    
    @objc func addNewReminder() {
            performSegue(withIdentifier: "addNewReminder", sender: self)
        }
    
    
    // Build Date:[Reminders] map
    func updateReminderMap() {
        remindersMap.removeAll() // empty map
        
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
        
        tableView.reloadData()
    }
    
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
    
    @IBAction func toggleEdit() {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
        }
    }

    // Set number of sections to number of date keys + completed section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return remindersMap.keys.count + 1
    }

    // Set number of section rows to number of reminders for each date
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == getCompletedSection() {
            // Configure completed cells
            let reminder = completedReminders[indexPath.row]
            
            cell.textLabel?.text = reminder.title
            cell.detailTextLabel?.text = reminder.description
            cell.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            cell.backgroundColor = .systemGray6
        } else {
            // Configure incompleted cells
            let date = getSectionDate(section: indexPath.section)
            guard let reminder = remindersMap[date]?[indexPath.row] else { return cell }
            
            cell.textLabel?.text = reminder.title
            cell.detailTextLabel?.text = reminder.description
            cell.imageView?.image = UIImage(systemName: "checkmark.circle")
        }
        return cell
    }
    
    // Handle deleting table row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Bruh")
        if editingStyle == .delete {
            print("Deleting", reminders.count)
            tableView.beginUpdates()
            if indexPath.section == getCompletedSection() {
                print("...completed")
                let removedReminder = completedReminders.remove(at: indexPath.row)
                Reminder.deleteReminder(removedReminder, from: &reminders)
            } else {
                print("...incompleted")
                let date = getSectionDate(section: indexPath.section)
                let removedReminder = remindersMap[date]?[indexPath.row]
                Reminder.deleteReminder(removedReminder!, from: &reminders)
            }
            updateReminderMap()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            print("Done", reminders.count)
        }
        
        // Handle deleting
        if editingStyle == .insert {
            if indexPath.section == getCompletedSection() {
                // Deleting from completed reminders
                tableView.beginUpdates()
                
                let removedReminder = completedReminders.remove(at: indexPath.row)
                
                // Remove from original reminders array using the id
                if let index = reminders.firstIndex(where: { $0.id == removedReminder.id }) {
                    reminders.remove(at: index)
                }
                
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                // Delete from incompleted reminders
                
                let date = getSectionDate(section: indexPath.section)
                
                tableView.beginUpdates()
                
                if var remindersForDate = remindersMap[date] {
                    // Remove reminder from date array
                    let removedReminder = remindersForDate.remove(at: indexPath.row)
                    
                    if remindersForDate.isEmpty {
                        // Remove date array and section if no more reminders exist
                        remindersMap.removeValue(forKey: date)
                        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade) // ???
                    } else {
                        // Delete table rows if more reminders exist
                        remindersMap[date] = remindersForDate // needed?
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                    // Temp: Remove from the original reminders array using the id
                    // Note: Should save data here (and build new remindersMap)
                    if let index = reminders.firstIndex(where: { $0.id == removedReminder.id }) {
                        reminders.remove(at: index)
                    }
                }
                
            }
            Reminder.saveReminders(reminders)
            
            tableView.endUpdates()
            
        }
    }



    
    // Move table row to a different date
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromDate = getSectionDate(section: fromIndexPath.section)
        let toDate = getSectionDate(section: to.section)
        
//        tableView.beginUpdates()
        
        // HELP HERE
        // consider: moving in same section to different row, moving to different row
        
//        tableView.endUpdates()
        
        
        
        print(remindersMap as AnyObject)
        print(fromDate, toDate)
    }
    

    
    // Set conditional rearranging of the table view
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // MARK: - Navigation
    
        
    @IBSegueAction func goToAddEdit(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> AddEditTableViewController? {
        return AddEditTableViewController(coder: coder, reminder: nil, currentUser: "")
    }
    
    @IBAction func unwindToRemindersTableViewController(_ unwindSegue: UIStoryboardSegue) {
//        if let sourceVC = unwindSegue.source as? AddEditTableViewController, let reminder = sourceVC.reminder {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                if selectedIndexPath.section == getCompletedSection() {
//                    completedReminders[selectedIndexPath.row] = reminder
//                } else {
//                    let date = getSectionDate(section: selectedIndexPath.section)
//                    remindersMap[date]?[selectedIndexPath.row] = reminder
//                }
//            } else {
//                reminders.append(reminder)
//            }
//            updateReminderMap()
//        }
    }

    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


    // MARK: Utils
    
    // Return Date with an offset of n days
    func fromToday(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to:  Calendar.current.startOfDay(for: Date()))!
    }
    
    func loadSampleDate() {
        reminders.append(Reminder(title: "MST Quiz 4", description: "Azure", dueDate:fromToday(days: -3)))
        reminders.append(Reminder(title: "Walk dog", description: "Don't forget water", dueDate:fromToday(days: -1)))
        reminders.append(Reminder(title: "MAP Assignment 3", description: "Help", dueDate:fromToday(days: 0)))
        reminders.append(Reminder(title: "Garbage", description: "Recycling and compost", dueDate:fromToday(days: 0)))
        reminders.append(Reminder(title: "PRJ Sprint 2", description: "AI addendum analyzing feature", dueDate:fromToday(days: 1)))
        reminders.append(Reminder(title: "MST Project 2", description: "Azure load balancing", dueDate:fromToday(days: 1)))
        reminders.append(Reminder(title: "MAP Assignment 3", description: "Fetching API date", dueDate:fromToday(days: 3)))
        
        reminders[1].toggleCompletion()
        reminders[4].toggleCompletion()
        
    }
    
}
