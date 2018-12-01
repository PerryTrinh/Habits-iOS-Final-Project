//
//  SessionCell.swift
//  Habits
//
//  Created by Perry Trinh on 11/29/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    let currentUser = CurrentUser()
    let sessionList = SessionList()
    
    @IBAction func switchPressed(_ sender: Any) {
        guard let indexPath = self.getIndexPath() else { return }
        let targetSession = self.sessionList.getSession(at: indexPath.row)
        
        if onSwitch.isOn {
            print("SESSION \(targetSession.name) ENABLED")
            targetSession.enable()
            self.currentUser.updateSessionEnable(toFix: targetSession)
        } else {
            print("SESSION \(targetSession.name) DISABLED")
            targetSession.disable()
            self.currentUser.disableNotifications(toDisable: targetSession)
        }
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("SUPER VIEW IS NOT UITABLEVIEW")
            return nil
        }
        return superView.indexPath(for: self)
    }
}
