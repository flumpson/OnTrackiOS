//
//  FollowerMapController.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/12/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import UIKit
import MapKit

class FollowerMapController: UIViewController, MKMapViewDelegate{
    
    var curSesh:PFObject!
    
    var curLoc:CLLocationCoordinate2D!

    @IBOutlet weak var mapView: MKMapView!
//================View Methods=============
    override func viewDidLoad() {
        self.mapView.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.grabSession()
    }
//=================End=====================
    

//=============delegate Method=============
//    called when the map update location
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
     
        self.translateToCoordinate2D()
//        // Add an annotation
//        MKPointAnnotation point =
//        point.coordinate = userLocation.coordinate;
//        point.title = @"Where am I?";
//        point.subtitle = @"I'm here!!!";
//        
//        [self.mapView addAnnotation:point];
        
        var point:MKPointAnnotation = MKPointAnnotation()
        if(self.curLoc != nil){
            point.coordinate = self.curLoc
            self.mapView.addAnnotation(point)
        }
    }
    
    
//==============End========================
    
    
//===================Parse Methods===============
    
//    grabs the current Session
    func grabSession(){
        let lc = LocalUser()
        var localUser = lc.getLocalUser()
        var query:PFQuery = PFQuery(className: "customUser")
        var newUser:PFObject = query.getObjectWithId(localUser.objectId)
        
        var curSession:PFObject! = newUser.objectForKey("session") as PFObject!
        
    
        if(curSession != nil){
            self.curSesh = curSession
        }
        
        

    }
    
//    transforms the parse data to a 2d coord
    func translateToCoordinate2D(){
        self.curSesh.fetchIfNeeded()
        var curLeader:PFObject! = self.curSesh["Leader"] as PFObject!
        curLeader.fetchIfNeeded()
        println(curLeader)
        if(curLeader != nil){
            var GPS:PFObject! = curLeader["GPSObject"] as PFObject!
            GPS.fetchIfNeeded()
            if(GPS != nil){
                var lat:CLLocationDegrees = GPS["Latitude"] as CLLocationDegrees
                var long:CLLocationDegrees = GPS["Longitude"] as CLLocationDegrees
                var coords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
                self.curLoc = coords
            }
        }
        
    }
    
//====================End========================
    
    
//=========================IBActions================
//    sets the follower active to false, and removes the session pointer from the follower user class, then pops to the root view controller
    @IBAction func exitButton(sender: AnyObject) {
            let lc = LocalUser()
            var localUser = lc.getLocalUser()
            var query:PFQuery = PFQuery(className: "customUser")
            var newUser:PFObject! = query.getObjectWithId(localUser.objectId)
        if(newUser != nil){
            newUser.setObject(false, forKey: "Active")
            newUser.removeObjectForKey("session")
            newUser.save()
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
//========================End=======================
}
