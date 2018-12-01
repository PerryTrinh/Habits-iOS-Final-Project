//
//  Activities.swift
//  Habits
//
//  Created by Perry Trinh on 11/30/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Activities: Hashable, Equatable {
    let dbRef = Database.database().reference()
    
    var key: String!
    var id: String!
    var name: String
    var enabled: Bool
    var numTimeInterval: Int
    var unitTimeInterval: String
    
    init(name: String, numTimeInterval: Int, unitTimeInterval: String, enabled: Bool) {
        id = Auth.auth().currentUser?.uid
        self.key = dbRef.child("Users").child(self.id).childByAutoId().key!
        
        self.name = name
        self.numTimeInterval = numTimeInterval
        self.unitTimeInterval = unitTimeInterval
        self.enabled = enabled
    }
    
    static func == (lhs: Activities, rhs: Activities) -> Bool {
        return lhs.name == rhs.name && lhs.numTimeInterval == rhs.numTimeInterval && lhs.unitTimeInterval == rhs.unitTimeInterval
    }
    
    public var hashValue: Int {
        return self.name.hashValue ^ self.numTimeInterval.hashValue ^ self.unitTimeInterval.hashValue
    }
}
