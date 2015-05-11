//
//  UIImage+Rotation.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 3/25/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation
extension UIImage {

    func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        var rotatedViewBox = UIView(frame: CGRectMake(0.0, 0.0, self.size.width, self.size.height))

        var t = CGAffineTransformMakeRotation(degreesToRadians(degrees))
        rotatedViewBox.transform = t
        var rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        var bitmap = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0)
        
        CGContextRotateCTM(bitmap, degreesToRadians(degrees))
        
        CGContextScaleCTM(bitmap, 1.0, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2.0, -self.size.height / 2.0, self.size.width, self.size.height), self.CGImage)

        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / 180.0
    }
    
}