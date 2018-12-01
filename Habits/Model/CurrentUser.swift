//
//  CurrentUser.swift
//  Habits
//
//  Created by Perry Trinh on 11/28/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

// TODO: Front end to initialize activities and sessions

class CurrentUser {
    var username: String!
    var id: String!
    
    let dbRef = Database.database().reference()
    
    init() {
        let currentUser = Auth.auth().currentUser
        username = currentUser?.displayName
        id = currentUser?.uid
    }
    
    func getAllReminders(completion: @escaping ([Reminders]) -> Void ) {
        var reminderList: [Reminders] = []
        dbRef.child("Users").child(self.id).child("reminders").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                guard let allReminders = snapshot.value as? [String:AnyObject] else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                for reminderKey in allReminders.keys {
                    let reminder = allReminders[reminderKey] as! Dictionary<String, Any>
                    guard let remindName = reminder["name"] else { continue }
                    guard let remindDesc = reminder["description"] else { continue }
                    guard let remindDateString = reminder["date"] else { continue }
                    guard let remindDate = dateFormatter.date(from: remindDateString as! String) else { continue }
                    guard let remindEnabled = reminder["enabled"] else { continue }

                    reminderList.append(Reminders(name: remindName as! String, description: remindDesc as! String, date: remindDate, enabled: remindEnabled as! Bool))
                }
                completion(reminderList)
            } else {
                completion(reminderList)
            }
        })
    }
    
    func getAllSessions(completion: @escaping ([Sessions]) -> Void) {
        var sessionList: [Sessions] = []
        dbRef.child("Users").child(self.id).child("sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                guard let allSessions = snapshot.value as? [String:AnyObject] else { return }
                
                for sessionKey in allSessions.keys {
                    let session = allSessions[sessionKey] as! Dictionary<String, Any>
                    print("Session Data")
                    for value in session.keys {
                        print("Value: \(value) and Data: \(session[value])")
                    }
                    guard let sessionName = session["name"] else { continue }
                    guard let sessionEnable = session["enabled"] else { continue }
                    
                    var sessionToAdd = Sessions(name: sessionName as! String, enabled: sessionEnable as! Bool)
                    
                    sessionList.append(sessionToAdd)
                }
                
                completion(sessionList)
            } else {
                completion(sessionList)
            }
        })
    }
    
    func addNewReminder(toAdd: Reminders) {
        // Set up local notification
        let content = UNMutableNotificationContent()
        content.title = toAdd.name
        content.body = toAdd.description
        content.sound = UNNotificationSound.default
        
        // TODO: figure out how to change Date to DateComponents
        let triggerDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: toAdd.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: toAdd.key, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        // Add reminder to database
        let reminderKey = toAdd.key!
        let info: [String: Any] = ["name": toAdd.getName(),
                    "description": toAdd.getDescription(),
                    "date": toAdd.getDateString(),
                    "enabled": true]
        
        let childUpdates = ["Users/\(self.id!)/reminders/\(reminderKey)": info]
        dbRef.updateChildValues(childUpdates)
    }
    
    func updateEnable(toFix: Reminders) {
        let reminderKey = toFix.key!
        let info: [String: Any] = ["name": toFix.getName(),
                                   "description": toFix.getDescription(),
                                   "date": toFix.getDateString(),
                                   "enabled": toFix.enabled]
        
        let childUpdates = ["Users/\(self.id!)/reminders/\(reminderKey)": info]
        dbRef.updateChildValues(childUpdates)
    }
    
    func addNewSession(toAdd: Sessions) {
        let sessionKey = toAdd.key!
        let info: [String: Any] = ["name": toAdd.name,
                                   "enabled": toAdd.enabled]
        
        let childUpdates = ["Users/\(self.id!)/sessions/\(sessionKey)": info]
        dbRef.updateChildValues(childUpdates)
    }
    
    func addAllSessionActivities(toAdd: Sessions) {
        let sessionKey = toAdd.key!
        var childUpdates: [String: Any] = [:]
        for activity in toAdd.allActivities {
            let activityKey = activity.key!
            let activityInfo: [String: Any] = ["numTimeInterval": activity.numTimeInterval,
                                "unitTimeInterval": activity.unitTimeInterval]
            childUpdates["Users/\(self.id!)/sessions/\(sessionKey)/\(activityKey)"] = activityInfo
        }
        print("THIS IS SESSION ACTIVITIES CHILD UPDATES")
        print(childUpdates)
        dbRef.updateChildValues(childUpdates)
    }
    
    func addSessionActivity(session: Sessions, activity: Activities) {
        let sessionKey = session.key!
        let activityKey = activity.key!
        let info: [String: Any] = ["name": activity.name,
                                   "numTimeInterval": activity.numTimeInterval,
                                   "unitTimeInterval": activity.unitTimeInterval]
        let childUpdates = ["Users/\(self.id!)/sessions/\(sessionKey)/\(activityKey)": info]
        dbRef.updateChildValues(childUpdates)
        
        session.addActivity(toAdd: activity)
    }
    
    func updateSessionEnable(toFix: Sessions) {
        let sessionKey = toFix.key!
        let info: [String: Any] = ["name": toFix.name,
                                   "enabled": toFix.enabled]
        
        let childUpdates = ["Users/\(self.id!)/sessions/\(sessionKey)": info]
        dbRef.updateChildValues(childUpdates)
        
        // Set up local notifications
        for activity in toFix.getAllActivities() {
            if activity.enabled {
                let content = UNMutableNotificationContent()
                content.title = activity.name
                content.body = "For Session \(toFix.name)"
                content.sound = UNNotificationSound.default
                
                var triggerDate = DateComponents()
                triggerDate.second = 0
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
                let request = UNNotificationRequest(identifier: activity.name, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
    
    func disableNotifications(toDisable: Sessions) {
        for activity in toDisable.getAllActivities() {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [activity.name])
        }
    }
}
