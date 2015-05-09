//
//  PFCloud+Extension.swift
//  SpeakEasy
//
//  Created by Bryce Langlotz on 5/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation

extension PFCloud {
    
    class func chargeUser(username:String!, numberOfPoints points:Int!, block:PFIdResultBlock) {
        var parameters = [NSObject:AnyObject]()
        
        parameters["username"] = username
        parameters["restaurantCode"] = points
        
        PFCloud.callFunctionInBackground("ChargeUser", withParameters: parameters, block: block)
    }
}