//
//  Reminder.swift
//  ToDoList
//
//  Created by Aryan Tuwar on 2024-07-31.
//

import Foundation
import UIKit

// Reminder class

class Reminder: Codable {
    var id: UUID
    var title: String
    var description: String?
    var dueDate: Date
    var isCompleted: Bool
    var image: UIImage?
    var username: String
    
    // Initializer
    init(title: String, description: String? = nil, dueDate: Date = Date(), isCompleted: Bool = false, image: UIImage? = nil, username: String = "ExampleUser123") {
        self.id = UUID()
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.image = image
        self.username = username
    }
    
    
    // MARK: Methods
    
    // Update fields
    func updateReminder(title: String?, description: String?, dueDate: Date?, image: UIImage?, username: String?) {
        self.title = title ?? self.title
        self.description = description ?? self.description
        self.dueDate = dueDate ?? self.dueDate
        self.image = image ?? self.image
        self.username = username ?? self.username
    }
    
    // Toggle completion status
    func toggleCompletion() {
        self.isCompleted.toggle()
    }
    
    
    // MARK: Static functions
    
    // Remove reminder from array of Reminders
    static func deleteReminder(_ reminder: Reminder, from reminders: inout [Reminder]) {
        reminders.removeAll { $0.id == reminder.id}
    }
    
    // Check and return if reminder exists in array of Reminders
    static func reminderExists(_ reminder: Reminder, in reminders: [Reminder]) -> Bool {
        return reminders.contains { $0.id == reminder.id }
    }
    
    // Find and return reminder in array of Reminders
    static func findReminder(_ reminder: Reminder, in reminders: [Reminder]) -> Reminder? {
        return reminders.first { $0.id == reminder.id }
    }
    
    // Format date to mon, dd yyyy
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case dueDate
        case isCompleted
        case image
        case username
    }
    
    // Encoding and decoding
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        dueDate = try container.decode(Date.self, forKey: .dueDate)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        if let imageData = try container.decodeIfPresent(Data.self, forKey: .image) {
            image = UIImage(data: imageData)
        }
        username = try container.decode(String.self, forKey: .username)
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(isCompleted, forKey: .isCompleted)
        if let image = image {
            let imageData = image.pngData()
            try container.encode(imageData, forKey: .image)
        }
        try container.encode(username, forKey: .username)
    }
    
    // MARK: - Date Persistence
    
    static var filePath: URL {
        let pathToDocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let filePath = pathToDocumentDirectory.appendingPathComponent("reminders").appendingPathExtension("plist")
        return filePath
    }
    
    // Save list of reminders
    static func saveReminders(_ reminders: [Reminder]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedReminders = try? propertyListEncoder.encode(reminders)
        try? encodedReminders?.write(to: filePath, options: .noFileProtection)
    }
    
    // Load saved reminders and return array
    static func loadSavedReminders() -> [Reminder] {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedReminderData = try? Data(contentsOf: filePath),
           let decodedReminders = try? propertyListDecoder.decode([Reminder].self, from: retrievedReminderData) {
            return decodedReminders
        }
        return []
    }
    
    // Load and save reminders for given user
    
    static func loadReminders(for username: String) -> [Reminder] {
        return loadSavedReminders().filter { $0.username == username }
    }
    
    static func saveReminders(_ reminders: [Reminder], for username: String) {
        let allReminders = loadSavedReminders().filter { $0.username != username } + reminders
        saveReminders(allReminders)
    }
}
