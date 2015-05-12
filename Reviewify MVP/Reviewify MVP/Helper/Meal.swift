//
//  Meal.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/12/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class Meal: PFObject, PFSubclassing {
    override class func initialize() {
        superclass()?.load()
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return Constants.Meals.ClassName
    }
    
    var claimed:Bool? {
        get {
            return self[Constants.Meals.Claimed] as! Bool?
        }
        set {
            self[Constants.Meals.Claimed] = newValue
        }
    }
    
    var claimedBy:String? {
        get {
            return self[Constants.Meals.ClaimedBy] as! String?
        }
        set {
            self[Constants.Meals.ClaimedBy] = newValue
        }
    }
    
    var potentialReward:Int? {
        get {
            return self[Constants.Meals.PotentialReward] as! Int?
        }
        set {
            self[Constants.Meals.PotentialReward] = newValue
        }
    }
    
    var restaurantObjectId:String? {
        get {
            return self[Constants.Meals.Restaurant] as! String?
        }
        set {
            self[Constants.Meals.Restaurant] = newValue
        }
    }
    
    var serverObjectId:String? {
        get {
            return self[Constants.Meals.Server] as! String?
        }
        set {
            self[Constants.Meals.Server] = newValue
        }
    }
}
