//
//  Double+Extension.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}