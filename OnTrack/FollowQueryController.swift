//
//  FollowQueryController.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/11/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import UIKit

class FollowQueryController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var titleField: UITextField!
    
    var userTitle:String! = ""
//    ============= view methods============
    override func viewDidLoad() {
        
    }
    
    
//    ================End===================
    
    
    ///===================Delegate Methods=============
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.userTitle = textField.text
        return true
    }
    
    //===================End===========================
    
    
//==================IBActions================
    
//    pops the navigation controller to the start screen
    @IBAction func cancelButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func followButton(sender: AnyObject) {
        if(self.titleField.text != ""){
            var session:SessionWrapper! = self.queryServer(self.userTitle)
            if(session.exists == true){
//                follow method
                self.followSession(session.sesh)
            }
            else{
                var alert = UIAlertView(title: "The Session Doesn't Exist", message:"You're ahead of your time", delegate: nil, cancelButtonTitle: "Thanks, I guess")
                alert.show()
                
            }
        }
        else{
            var alert = UIAlertView(title: "Missing The Session Name", message:"You can be more creative than that!", delegate: nil, cancelButtonTitle: "I got this")
            alert.show()
        }
    }
//=================End======================
    
    
//==================Parse Functions===========
    
    //    queries the server for the session, and returns it as part of a wrapper class
    func queryServer(userTitl:String) -> SessionWrapper{
        var query:PFQuery = PFQuery(className: "Session")
        
        query.whereKey("Title", containsString: userTitl)
        
        
        var session:PFObject! = PFObject(className: "Session")!
        
        session = query.getFirstObject()
        
        var sessionWrap:SessionWrapper = SessionWrapper(sesh: session, exists: false)
        
        sessionWrap.sesh = session
        
        if(session != nil){
            sessionWrap.exists = true
        }
        
        return sessionWrap
    }
    
//   takes in a session and adds the follower to it
    func followSession(session:PFObject){
        
        let lc = LocalUser()
        let temp = lc.getLocalUser()
        var query:PFQuery = PFQuery(className: "customUser")
        var newUser:PFObject = query.getObjectWithId(temp.objectId)
        
        
        newUser.setObject(true, forKey: "Active")
        session.addObject(newUser, forKey: "Followers")
        session.saveInBackgroundWithTarget(nil, selector: nil)
        
        newUser.setObject(session, forKey: "session")
    }
    
//==================End=======================
    
}
