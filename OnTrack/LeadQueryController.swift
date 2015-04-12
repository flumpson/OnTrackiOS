//
//  LeadQueryController.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/11/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import UIKit

class LeadQueryController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    
    var userTitle:String! = ""
    
//    ============= view methods============
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }


//    ================End===================
    
    
    
//================IBActions==================
    
//    creates the session
    @IBAction func createButton(sender: AnyObject) {
        if(self.titleField.text != ""){
            if(self.queryServer(self.userTitle)){
                self.createSession(self.userTitle)
                self.performSegueWithIdentifier("leaderMap", sender: self)
            }
            else{
                var alert = UIAlertView(title: "The Session Already Exists", message:"Sorry, someone beat you to it", delegate: nil, cancelButtonTitle: "Ugh, fine")
                alert.show()
            }
        }
        else{
            var alert = UIAlertView(title: "Missing The Session Name", message:"You can be more creative than that!", delegate: nil, cancelButtonTitle: "I got this")
            alert.show()
        }
    }
    
//    returns to the title screen
    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
//==================End======================
    
    
//===================Delegate Methods=============
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.userTitle = textField.text
        return true
    }
    
//===================End===========================
    
    
//===================Parse Functions===============
    
    
//    queries the server for the session,
//    return true: session does not exist
//    return false: session does exist
    func queryServer(userTitl:String) -> Bool{
        var query:PFQuery = PFQuery(className: "Session")
        
        query.whereKey("Title", containsString: userTitl)
        
        
        var session:PFObject! = PFObject(className: "Session")
        
        session = query.getFirstObject()
        
        if(session != nil){
            return false
        }
        return true
        
    }
    
//    creates a session and initializes its fields to the leader who created it
    func createSession(title:String){
        
        let lc = LocalUser()
        var newSession:PFObject = PFObject(className: "Session")
        var localUser = lc.getLocalUser()
        var query:PFQuery = PFQuery(className: "customUser")
        var newUser:PFObject = query.getObjectWithId(localUser.objectId)
        newUser.setObject(true, forKey: "Active")
        
        
        
        
        newSession.setObject(newUser, forKey: "Leader")
        newSession.setObject(title, forKey: "Title")
        newSession.setObject(true, forKey: "Active")
        newSession.save()
        newUser.setObject(newSession, forKey: "session")
        newUser.saveInBackgroundWithTarget(nil, selector: nil)
    }
    
    
//===================End=============================

}
