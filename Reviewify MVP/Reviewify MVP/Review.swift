//
//  Review.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/22/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

class Review {
    
    var object: PFObject!
    
    init(restaurant:String!, mealCode:String!, reviewText:String!, rating:Float!, reward:Int!) {
        object = PFObject(className: restaurant)
        object.setValue(mealCode, forKey: Constants.Review.Meal)
        object.setValue(reviewText, forKey: Constants.Review.Review)
        object.setValue("\(rating)", forKey: Constants.Review.StarRating)
        object.setValue(reward, forKey: Constants.Review.Reward)
        
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if let error = error {
                println(error.description)
            }
        }
    }
}
