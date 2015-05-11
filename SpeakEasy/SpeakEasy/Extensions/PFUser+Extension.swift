//
//  PFUser+Extension.swift
//  SpeakEasy: Restaurant
//
//  Created by Bryce Langlotz on 4/23/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation

extension PFUser {

    func isRestaurant(block:PFIdResultBlock) {
        var parameters = [String:AnyObject]()
        parameters["username"] = PFUser.currentUser()?.username
        PFCloud.callFunctionInBackground("isRestaurant", withParameters: parameters, block: block)
    }
}