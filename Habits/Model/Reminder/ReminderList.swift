//
//  ReminderList.swift
//  Habits
//
//  Created by Perry Trinh on 11/26/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import Foundation

class ReminderList {
    static var list = Set<Reminders>()
    
    func add(reminder: Reminders) {
        if !ReminderList.list.contains(reminder) {
            ReminderList.list.insert(reminder)
        }
    }
    
    func getSize() -> Int {
        return ReminderList.list.count
    }
    
    func getAllReminders() -> [Reminders] {
        return Array(ReminderList.list)
    }
    
    func getReminder(at: Int) -> Reminders {
        return ReminderList.list[ReminderList.list.index(ReminderList.list.startIndex, offsetBy: at)]
    }
    
    func printAllReminders() {
        for reminder in ReminderList.list {
            reminder.printReminder()
        }
    }
}
