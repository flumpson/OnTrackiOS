//
//  LeaderMapController.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/11/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import UIKit
import MapKit

class LeaderMapController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var leaderMap: MKMapView!
    
    override func viewDidLoad() {
        self.leaderMap.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    
//  ============  Delegate methods=============
    
//    occurs when the user location is updated
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        println("happening")
        self.updateUserLoc()
    }
    
//============== End =======================
    
    
//==============Parse Methods=============
//    adds a new GPS point to the user GPS Array
    func updateUserLoc(){
        var GPS:PFObject = PFObject(className: "GPSObject")

        let lc = LocalUser()
        var localUser = lc.getLocalUser()
        var query:PFQuery = PFQuery(className: "customUser")
        var newUser:PFObject = query.getObjectWithId(localUser.objectId)
        
        var coords = self.leaderMap.userLocation.location
        
        coords.coordinate.latitude
        coords.coordinate.longitude
        
        var curSesh:PFObject! = newUser.objectForKey("session") as PFObject!
        GPS.setObject(curSesh, forKey: "session")
        
        GPS.setObject(coords.coordinate.latitude, forKey: "Latitude")
        GPS.setObject(coords.coordinate.longitude, forKey: "Longitude")
        GPS.setObject(newUser, forKey: "user")
        GPS.save()
        
        newUser.setObject(GPS, forKey: "GPSObject")
        newUser.saveInBackgroundWithTarget(nil, selector: nil)
        
        
    }
//===============End===================
    
    
//================IBActions============

//    removes the session pointer
    @IBAction func exitButton(sender: AnyObject) {
        let lc = LocalUser()
        var newSession:PFObject = PFObject(className: "Session")
        var localUser = lc.getLocalUser()
        var query:PFQuery = PFQuery(className: "customUser")
        var newUser:PFObject = query.getObjectWithId(localUser.objectId)
        
        var session:PFObject! = newUser.objectForKey("session") as PFObject!
        
        session.setObject(false, forKey: "Active")
        
        session.save()
        
        newUser.removeObjectForKey("session")
        newUser.saveInBackgroundWithTarget(nil, selector: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
//=================End================
}
