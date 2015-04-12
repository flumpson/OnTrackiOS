//
//  sessionWrapper.swift
//  OnTrack
//
//  Created by Ryan Brandt on 4/11/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

import Foundation

//Wrapper class to get around the function crshing when it returned nil
struct SessionWrapper {
    var sesh:PFObject!
    var exists:Bool!
}