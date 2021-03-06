//
//  StudentRosterViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class StudentRosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var rosterState = 0
    private var students = [PFObject]()
    private var rosterID = ""
    private var rosterType = 0
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var studentListTable: UITableView!

    private var navTitle = ""
    private var forwardedStudentID = ""
    private var forwardedStudentLastName = ""
    private var forwardedStudentFirstName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = navTitle
        getStudents()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getStudents() {
        let query = PFQuery(className: "StudentRosters")
        query.whereKey("username", equalTo: (currentUser?.username)!)
        query.whereKey("rosterID", equalTo: rosterID)
        query.orderByAscending("studentLastName")

        if (rosterState == 1) {
            let signedOutSubquery = PFQuery(className: "SignOuts")
            let date = Date()
            signedOutSubquery.whereKey("day", equalTo: date.getCurrentDay())
            signedOutSubquery.whereKey("month", equalTo: date.getCurrentMonth())
            signedOutSubquery.whereKey("year", equalTo: date.getCurrentYear())
            signedOutSubquery.whereKey("rosterID", equalTo: rosterID)
            query.whereKey("studentID", doesNotMatchKey: "studentID", inQuery: signedOutSubquery)
            query.whereKey(date.getCurrentWeekday(), equalTo: true)
        }
        do {
            students = try query.findObjects()
        } catch {
        }
    }
    
    func setState(state: Int) {
        rosterState = state
    }
    
    func setTitleValue(title: String) {
        navTitle = title
    }
    
    func setRosterID(id: String) {
        rosterID = id
    }

    func setRosterType(type: Int) {
        rosterType = type
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let student: PFObject = students[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let name = (student["studentFirstName"] as? String)! + " " + (student["studentLastName"] as? String)!
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student: PFObject = students[(indexPath.row)]
        forwardedStudentID = student["studentID"] as! String
        forwardedStudentLastName = student["studentLastName"] as! String
        forwardedStudentFirstName = student["studentFirstName"] as! String
        segue()
    }
    
    private func segue() {
        if (rosterState == 0) {
            performSegueWithIdentifier("StudentRosterToStudentProfile", sender: self)
        } else if (rosterState == 1) {
            performSegueWithIdentifier("StudentRosterToSignOut", sender: self)
        } else if (rosterState == 2) {
            performSegueWithIdentifier("StudentRosterToScheduleAbsence", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (rosterState == 2) {
            let savc = segue.destinationViewController as? ScheduleAbsenceViewController
            savc?.setStudentID(forwardedStudentID)
            savc?.setStudentLastName(forwardedStudentLastName)
            savc?.setStudentFirstName(forwardedStudentFirstName)
        } else if (rosterState == 0) {
            let sivc = segue.destinationViewController as? StudentInfoViewController
            sivc?.setStudentID(forwardedStudentID)
        } else if (rosterState == 1) {
            let sovc = segue.destinationViewController as? SignOutViewController
            sovc?.setStudentID(forwardedStudentID)
            sovc?.setTitleValue(forwardedStudentFirstName + " " + forwardedStudentLastName)
            sovc?.setRosterType(rosterType)
            sovc?.setRosterID(rosterID)
        }
    }
    
    @IBAction func studentSelectUnwind(segue: UIStoryboardSegue) {
        getStudents()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.studentListTable.reloadData()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
