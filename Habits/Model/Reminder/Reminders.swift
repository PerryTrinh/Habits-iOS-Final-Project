//
//  Reminders.swift
//  Habits
//
//  Created by Perry Trinh on 11/26/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

public class Reminders: Equatable, Hashable {
    var key: String!
    var id: String!
    var name: String
    var description: String
    var date: Date
    var enabled: Bool
    
    let dbRef = Database.database().reference()
    
    init(name: String, description: String, date: Date, enabled: Bool) {
        id = Auth.auth().currentUser?.uid
        self.key = dbRef.child("Users").child(self.id).childByAutoId().key!
        
        self.name = name
        self.description = description
        self.date = date
        self.enabled = enabled
    }
    
    func printReminder() {
        print("Reminder: \nName: \(self.name)\nDescription: \(self.description)\nDate: \(self.getDateString())\nEnabled: \(self.enabled)")
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: self.date)
    }
    
    func getReadableDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd, HH:mm"
        return dateFormatter.string(from: self.date)
    }
    
    func disable() {
        self.enabled = false
    }
    
    func enable() {
        self.enabled = true
    }
    
    public static func == (lhs: Reminders, rhs: Reminders) -> Bool {
        return lhs.name == rhs.name && lhs.date == rhs.date && lhs.description == rhs.description
    }
    
    public var hashValue: Int {
        return name.hashValue ^ description.hashValue ^ date.hashValue
    }
}
