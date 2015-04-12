//
//  localUser.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/11/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import Foundation


class LocalUser {
    
    
//    Queries the local Parse datastore for the local user
//    Return true: if user if found
//    Return false: if user is not found
    func isLocalUser() ->Bool{
        var localQuery:PFQuery = PFQuery(className: "customUser")
        localQuery.fromLocalDatastore()
        var user:PFObject! = localQuery.getFirstObject() as PFObject!
        
        if(user != nil){
            println(user)
            return true
        }
        return false
    }
    
    
    
    //    Queries the local Parse datastore for the local user
    //    Return: the user
    func getLocalUser() ->PFObject{
        var localQuery:PFQuery = PFQuery(className: "customUser")
        localQuery.fromLocalDatastore()
        var user:PFObject! = localQuery.getFirstObject() as PFObject!
        
        return user
    }
    
//    creates a new user, and saves it to local datastore
    func createNewLocalUser(){
        var user = PFObject(className: "customUser")
        user.saveInBackgroundWithTarget(nil, selector: nil)
        user.pin()
        println("creating new user")
    }
}