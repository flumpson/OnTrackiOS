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
    
    var update:Bool! = true
    
    override func viewDidLoad() {
        self.leaderMap.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: false)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "appTerminated:",
            name: UIApplicationWillTerminateNotification,
            object: nil)
//        leaderAnn = LeaderAnnotation(coordinate: self.leaderMap.userLocation.coordinate, title: "", subtitle: "")
//        self.leaderMap.addAnnotation(leaderAnn)
    }

    
//  ============  Delegate methods=============
    
//    occurs when the user location is updated
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        
        var region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000)
        self.leaderMap.setRegion(self.leaderMap.regionThatFits(region), animated: true)
        println("happening")
        self.updateUserLoc()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        static NSString* AnnotationIdentifier = @"Annotation";
//        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
//        
//        if (!pinView) {
//            
//            MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
//            if (annotation == mapView.userLocation){
//                customPinView.image = [UIImage imageNamed:@"myCarImage.png"];
//            }
//            else{
//                customPinView.image = [UIImage imageNamed:@"mySomeOtherImage.png"];
//            }
//            customPinView.animatesDrop = NO;
//            customPinView.canShowCallout = YES;
//            return customPinView;
//            
//        } else {
//            
//            pinView.annotation = annotation;
//        }
        var pinView:MKPinAnnotationView! = self.leaderMap.dequeueReusableAnnotationViewWithIdentifier("Annotation") as MKPinAnnotationView!
    
        if(pinView == nil){
            
            var customLead = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            
            customLead.image = UIImage(named: "leaderPin")
            return customLead
            
        }
        else{
            pinView.annotation = annotation
            return pinView
        }
    }
    
//============== End =======================
    
    
//==============Parse Methods=============
//    adds a new GPS point to the user GPS Array
    func updateUserLoc(){
        if(self.update == true){
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
        
        
    }
//===============End===================
    
    
//================IBActions============

//    removes the session pointer
    @IBAction func exitButton(sender: AnyObject) {
        self.endSession()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
//=================End================
    
    
//===========auxilliary function================
    func appTerminated(notification:NSNotification){
        self.endSession()
    }
    
//    removes the session pointer and sets the session to inactive
    func endSession(){
        self.update = false
        let lc = LocalUser()
        var newSession:PFObject = PFObject(className: "Session")
        var localUser = lc.getLocalUser()
        var query:PFQuery = PFQuery(className: "customUser")
        var newUser:PFObject = query.getObjectWithId(localUser.objectId)
        println(newUser)
        newUser.fetchIfNeeded()
//        
        var session:PFObject! = newUser.objectForKey("session") as PFObject!
        session.fetchIfNeeded()
//
        session.setObject(false, forKey: "Active")
//
        session.save()
        
        println(newUser["session"])
//
        if(newUser["session"] != nil){
            newUser.setObject(NSNull(), forKey: "session")
            newUser.save()
        }
    }
//===========End===============================
}
