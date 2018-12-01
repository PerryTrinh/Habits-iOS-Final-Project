//
//  ReminderCell.swift
//  Habits
//
//  Created by Perry Trinh on 11/29/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    let reminderList = ReminderList()
    let currentUser = CurrentUser()
    
    @IBAction func switchPressed(_ sender: Any) {
        guard let indexPath: IndexPath = self.getIndexPath() else { return }
        let targetReminder = reminderList.getReminder(at: indexPath.row)
        if reminderSwitch.isOn {
            print("ENABLED")
            targetReminder.enable()
        } else {
            print("DISABLED")
            targetReminder.disable()
        }
        self.currentUser.updateEnable(toFix: targetReminder)
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("SUPER VIEW IS NOT UITABLEVIEW")
            return nil
        }
        return superView.indexPath(for: self)
    }
}
