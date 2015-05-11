//
//  PFCloud+Extension.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/22/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation

extension PFCloud {
    
    class func reviewRestaurantInBackground(restaurantCode:String!, mealCode:String!, potentialReward:Int!, currentUsername:String!, block: PFIdResultBlock) {
        
        var parameters = [NSObject:AnyObject]()
        
        parameters["username"] = currentUsername
        parameters["restaurantCode"] = restaurantCode
        parameters["mealCode"] = mealCode
        parameters["potentialReward"] = potentialReward
        
        PFCloud.callFunctionInBackground("ReviewMeal", withParameters: parameters, block: block)
    }
    
    class func verifyMeal(restaurantCode:String!, mealCode:String!, block: PFIdResultBlock) {
        var parameters = [NSObject:AnyObject]()
        parameters["restaurantCode"] = restaurantCode
        parameters["mealCode"] = mealCode
        
        PFCloud.callFunctionInBackground("VerifyMeal", withParameters: parameters, block: block)
    }
    
}