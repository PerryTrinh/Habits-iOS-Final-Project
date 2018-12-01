//
//  Sessions.swift
//  Habits
//
//  Created by Perry Trinh on 11/29/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class Sessions: Hashable, Equatable {
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    let dbRef = Database.database().reference()
    
    var key: String!
    var id: String!
    var name: String
    var enabled: Bool
    var allActivities = Set<Activities>()
    
    init(name: String, enabled: Bool) {
        id = Auth.auth().currentUser?.uid
        self.key = dbRef.child("Users").child(self.id).childByAutoId().key!
        
        self.name = name
        self.enabled = enabled
    }
    
    func enable() {
        self.enabled = true
    }
    
    func disable() {
        self.enabled = false
    }
    
    func getNumActivities() -> Int {
        return self.allActivities.count
    }
    
    func addActivity(toAdd: Activities) {
        self.allActivities.insert(toAdd)
    }
    
    func getActivity(at: Int) -> Activities {
        return self.allActivities[self.allActivities.index(self.allActivities.startIndex, offsetBy: at)]
    }
    
    func getAllActivities() -> [Activities] {
        return Array(self.allActivities)
    }
    
    public var hashValue: Int {
        return self.name.hashValue ^ self.id.hashValue
    }
    
    static func == (lhs: Sessions, rhs: Sessions) -> Bool {
        return lhs.name == rhs.name
    }
}
