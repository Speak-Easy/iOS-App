//
//  Global Constants.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/16/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation
class Constants {
    struct UserKey {
        static let TotalRewards = "total_rewards"
    }
    
    struct RestaurantKey {
        static let Name = "name"
        static let Location = "location"
    }
    
    struct MealValidation {
        static let ClassName = "Meals"
        static let MealID = "objectId"
        static let Claimed = "claimed"
        static let ClaimedBy = "claimed_by"
        static let Restaurant = "restaurant"
    }
    
    struct Review {
        static let Review = "review"
        static let StarRating = "star_rating"
        static let Reward = "reward"
        static let Meal = "meal"
        static let Restaurant = "restaurant_objectId"
        static let Reviewer = "uploader_username"
        static let ClassName = "Reviews"
    }
}
