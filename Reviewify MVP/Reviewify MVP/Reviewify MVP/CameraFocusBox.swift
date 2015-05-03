//
//  CameraFocusBox.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import Foundation

class CameraFocus: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
        var selectionAnimation = CABasicAnimation(keyPath: "borderColor")
        selectionAnimation.toValue = UIColor.blueColor().CGColor
        selectionAnimation.repeatCount = 8
        self.layer.addAnimation(selectionAnimation, forKey: "selectionAnimation")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}