//
//  ExpandedSessionViewController.swift
//  Habits
//
//  Created by Perry Trinh on 11/29/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class ExpandedSessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var expandedSessionTableView: UITableView!
    var session: Sessions? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let relevantSession = session else { return 0 }
        return relevantSession.getNumActivities()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.expandedSessionTableView.dequeueReusableCell(withIdentifier: "expandedSessionTableViewCell") as! ActivityCell
        let index = indexPath.row
        let relevantActivity = self.session?.getActivity(at: index)
        cell.nameText.text = relevantActivity?.name
        cell.numTimeIntervalText.text = String(relevantActivity!.numTimeInterval)
        cell.unitTimeIntervalText.text = relevantActivity?.unitTimeInterval
        cell.onSwitch.isOn = (relevantActivity?.enabled)!
        return cell
    }
    
    override func viewDidLoad() {
        expandedSessionTableView.delegate = self
        expandedSessionTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(segueToNewActivity))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let real = self.session {
            print("YAY IT SENT OVER DATA")
            print(real.name)
        } else {
            print("OH NO IT DIDN'T SEND OVER DATA")
        }
        self.expandedSessionTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewActivityViewController {
            let dest = segue.destination as? NewActivityViewController
            dest?.relevantSession = self.session
        }
    }
    
    @objc func segueToNewActivity() {
        performSegue(withIdentifier: "toNewActivityViewController", sender: self)
    }
    
    @IBAction func unwindSegueToExpandedSessionView(segue:UIStoryboardSegue) { }
}
