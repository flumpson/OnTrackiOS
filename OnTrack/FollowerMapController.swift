//
//  FollowerMapController.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/12/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FollowerMapController: UIViewController, MKMapViewDelegate{
    
    var curSesh:PFObject!
    
    var curLoc:CLLocationCoordinate2D!

    @IBOutlet weak var mapView: MKMapView!
//================View Methods=============
    override func viewDidLoad() {
        self.mapView.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.grabSession()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "appTerminatedFollow:",
            name: UIApplicationWillTerminateNotification,
            object: nil)
    }
//=================End=====================
    

//=============delegate Method=============
//    called when the map update location
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        

        var span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 200, longitudeDelta: 200)
     
        self.translateToCoordinate2D()
        
        
//        // Add an annotation
//        MKPointAnnotation point =
//        point.coordinate = userLocation.coordinate;
//        point.title = @"Where am I?";
//        point.subtitle = @"I'm here!!!";
//        
//        [self.mapView addAnnotation:point];
        
        
        
        if(self.curLoc != nil){
            var dist = self.getDistanceFromPoints(userLocation.coordinate, point2: self.curLoc)
            var region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, dist,dist)
            
            self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
            
            
            var point:FollowAnnotation = FollowAnnotation(coordinate: self.curLoc, title: "", subtitle: "")
            self.mapView.addAnnotation(point)
        }
    }
    
//    returns the distance in meters between two geopoints
    func getDistanceFromPoints(point1:CLLocationCoordinate2D,point2:CLLocationCoordinate2D) ->CLLocationDistance{
        
        var tPoint1:CLLocation = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
        
        var tPoint2:CLLocation = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
        
        var dist:CLLocationDistance = tPoint1.distanceFromLocation(tPoint2)
        return dist
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if(annotation.isKindOfClass(FollowAnnotation)){
            
            var follower:FollowAnnotation! = annotation as FollowAnnotation!
            
            var view:MKAnnotationView! = self.mapView.dequeueReusableAnnotationViewWithIdentifier("Follower")
            
            if(view == nil){
                println("happening")
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: "Follower")
            }
            else{
                view.annotation = annotation
            }
            view.image = UIImage(named: "followerPin")
            return view
        }
        
        
        var pinView:MKPinAnnotationView! = self.mapView.dequeueReusableAnnotationViewWithIdentifier("Annotation") as MKPinAnnotationView!
        
        
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

        self.endSession()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
//========================End=======================
    

//===========auxilliary function================
    func appTerminatedFollow(notification:NSNotification){
        self.endSession()
    }
    
    //    removes the session pointer and sets the session to inactive
    func endSession(){
        let lc = LocalUser()
        var localUser = lc.getLocalUser()
        var query:PFQuery = PFQuery(className: "customUser")
        var newUser:PFObject! = query.getObjectWithId(localUser.objectId)
        if(newUser != nil){
            newUser.setObject(false, forKey: "Active")
            newUser.removeObjectForKey("session")
            newUser.save()
        }
    }
//===========End===============================
    
}
