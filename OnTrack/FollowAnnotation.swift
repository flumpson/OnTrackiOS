//
//  LeaderAnnotation.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/12/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import Foundation

import MapKit

//creating custom pin for the leader
class FollowAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    
    func annotationView()->MKAnnotationView{
        var view:MKPinAnnotationView = MKPinAnnotationView(annotation: self, reuseIdentifier: "Follower")
        
        view.enabled = true
        view.image = UIImage(named: "followerPin.png")
        
        return view
    }
    
}