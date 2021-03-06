//
//  SignOutViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 12/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignOutViewController: UIViewController {

    private var studentID = ""
    private var rosterType = 0
    private var signOutGuardian = ""
    private var rosterID = ""

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var signatureBox: SignatureView!
    private var navTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleBar.title = "Sign Out " + navTitle

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStudentID(id: String) {
        studentID = id
    }

    func setTitleValue(title: String) {
        navTitle = title
    }

    func setRosterType(type: Int) {
        rosterType = type
    }

    func setRosterID(id: String) {
        rosterID = id
    }

    @IBAction func clearSignature(sender: AnyObject) {
        signatureBox.setLines([])
        signatureBox.setNeedsDisplay()
    }

    @IBAction func signOut(sender: AnyObject) {
        if (/*signOutGuardian != "" ||*/ !signatureBox.getLines().isEmpty) {
            let signOutRecord = PFObject(className: "SignOuts")
            signOutRecord["studentID"] = studentID
            signOutRecord["signOutGuardian"] = signOutGuardian
            signOutRecord["rosterType"] = rosterType
            signOutRecord["rosterID"] = rosterID
            let timestamp = Date()
            signOutRecord["day"] = timestamp.getCurrentDay()
            signOutRecord["month"] = timestamp.getCurrentMonth()
            signOutRecord["year"] = timestamp.getCurrentYear()
            signOutRecord["hour"] = timestamp.getCurrentHour()
            signOutRecord["minute"] = timestamp.getCurrentMinute()
            signOutRecord["username"] = (currentUser?.username)!

            signOutRecord.saveInBackgroundWithBlock {
                (success: Bool, error:NSError?) -> Void in
                if(success) {
                    print("Saved")
                    self.performSegueWithIdentifier("SignOutToStudentSelectUnwind", sender: self)
                }
                else {
                    print("Error")
                }
            }
        } else {
            print("error message")
        }
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
