//
//  PFUser+Extension.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/12/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation

extension PFUser {
    func getScannedMealsInBackgroundWithBlock(block:PFArrayResultBlock) {
        var query = PFQuery(className: "Meals")
        query.findObjectsInBackgroundWithBlock(block)
    }
}