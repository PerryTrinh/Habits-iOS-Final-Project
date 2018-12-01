//
//  SessionList.swift
//  Habits
//
//  Created by Perry Trinh on 11/30/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import Foundation

class SessionList {
    static var list = Set<Sessions>()
    
    func add(session: Sessions) {
        if !SessionList.list.contains(session) {
            SessionList.list.insert(session)
        }
    }
    
    func getSize() -> Int {
        return SessionList.list.count
    }
    
    func getAllSessions() -> [Sessions] {
        return Array(SessionList.list)
    }
    
    func getSession(at: Int) -> Sessions {
        return SessionList.list[SessionList.list.index(SessionList.list.startIndex, offsetBy: at)]
    }
}
