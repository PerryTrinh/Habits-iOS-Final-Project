//
//  SessionsViewController.swift
//  Habits
//
//  Created by Perry Trinh on 11/6/18.
//  Copyright © 2018 Perry Trinh. All rights reserved.
//

import UIKit

class SessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var sessionsTableView: UITableView!
    let sessionList = SessionList()
    let currentUser = CurrentUser()
    var relevantSessionForSegue: Sessions?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sessionList.getSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sessionsTableView.dequeueReusableCell(withIdentifier: "sessionTitleCell") as! SessionCell
        let index = indexPath.row
        let relevantSession = self.sessionList.getSession(at: index)
        cell.nameText.text = relevantSession.name
        cell.onSwitch.isOn = relevantSession.enabled
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let relevantSession = self.sessionList.getSession(at: index)
        self.relevantSessionForSegue = relevantSession
        
        performSegue(withIdentifier: "toExpandedSessionsViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ExpandedSessionViewController {
            let dest = segue.destination as? ExpandedSessionViewController
            dest?.session = self.relevantSessionForSegue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionsTableView.delegate = self
        sessionsTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(segueToNewSession))
    }
    
    @objc func segueToNewSession() {
        self.performSegue(withIdentifier: "toNewSessionViewController", sender: self)
    }
    
    @IBAction func unwindSegueToSessionView(segue:UIStoryboardSegue) { }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VIEW DID APPEAR IN SESSIONS")
        self.sessionsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentUser.getAllSessions(completion: { (sessionList) in
            for session in sessionList {
                print("Yay")
                self.sessionList.add(session: session)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
