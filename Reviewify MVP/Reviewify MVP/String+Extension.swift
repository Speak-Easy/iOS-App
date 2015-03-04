//
//  String+Extension.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 2/24/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation

extension String {
    func stripNonAlphanumeric() -> String {
        return "".join((self as NSString).componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet) as [String])
    }
}