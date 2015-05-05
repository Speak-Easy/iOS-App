//
//  Global Constants.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/16/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation
class Constants {
    struct Restaurants {
        static let Name = "restaurant_name"
        static let Location = "location"
    }
    
    struct Servers {
        static let ClassName = "Servers"
        static let FirstName = "first_name"
        static let ObjectId = "objectId"
    }
    
    struct Meals {
        static let ClassName = "Meals"
        static let MealID = "objectId"
        static let Claimed = "claimed"
        static let ClaimedBy = "claimed_by"
        static let Restaurant = "restaurant_objectId"
        static let PotentialReward = "potential_reward"
        static let Server = "server_objectId"
    }
    
    struct Review {
        static let Review = "review"
        static let StarRating = "star_rating"
        static let Reward = "reward"
        static let Meal = "meal_objectId"
        static let Restaurant = "restaurant_objectId"
        static let Reviewer = "uploader_username"
        static let ClassName = "Reviews"
    }
    
    struct Deals {
        static let Restaurant = "restaurant_objectId"
        static let ClassName = "Deals"
        static let Information = "information"
        static let Cost = "cost"
    }
}
