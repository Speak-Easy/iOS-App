//
//  ImportantInfoView.swift
//  Ticket Trader
//
//  Created by Bryce Langlotz on 9/29/14.
//  Copyright (c) 2014 Bryce Langlotz. All rights reserved.
//

import UIKit

enum  ImportantInformationType: Int {
    case Information
    case Warning
    case Error
}

class ImportantInformationView: UIView {

    private var clippingContentView: UIView
    private var backgroundColorView: UIView
    private var borderView: UIView
    private var leftBarView: UIView
    private var showingMessage:Bool
    var actionLabel: UITextView
    var type:ImportantInformationType = ImportantInformationType.Error {
        didSet {
            switch type {
            case ImportantInformationType.Information:
                self.backgroundColorView.backgroundColor = UIColor.greenColor()
                self.leftBarView.backgroundColor = UIColor.algorithmsGreen()
                self.actionLabel.textColor = UIColor.algorithmsGreen()
                self.borderView.layer.borderColor = UIColor.algorithmsGreen().CGColor
                self.clippingContentView.layer.borderColor = UIColor.algorithmsGreen().CGColor
            case ImportantInformationType.Error:
                self.backgroundColorView.backgroundColor = UIColor.redColor()
                self.leftBarView.backgroundColor = UIColor.redColor()
                self.actionLabel.textColor = UIColor.redColor()
                self.borderView.layer.borderColor = UIColor.redColor().CGColor
                self.clippingContentView.layer.borderColor = UIColor.redColor().CGColor
            default:
                println("Invalid ImportantInformationType")
            }
        }
    }
    
    private let ImportantActionViewLeftBarWidth: CGFloat = 8.0
    private let ImportantActionViewTextLeftBuffer: CGFloat = 8.0

    required init(coder aDecoder: NSCoder) {
        self.clippingContentView = UIView(frame: CGRectZero)
        self.clippingContentView.clipsToBounds = true
        self.clippingContentView.backgroundColor = UIColor.whiteColor()
        self.clippingContentView.layer.borderWidth = 1.0
        self.clippingContentView.layer.borderColor = UIColor.redColor().CGColor
        
        self.backgroundColorView = UIView(frame: CGRectZero)
        self.backgroundColorView.backgroundColor = UIColor.redColor()
        self.backgroundColorView.alpha = 0.1
        
        self.borderView = UIView(frame: CGRectZero)
        self.borderView.backgroundColor = UIColor.redColor()
        
        self.leftBarView = UIView(frame: CGRectZero)
        self.leftBarView.backgroundColor = UIColor.redColor()
        
        self.actionLabel = UITextView(frame: CGRectZero)
        self.actionLabel.backgroundColor = UIColor.clearColor()
        self.actionLabel.font = UIFont.systemFontOfSize(14.0)
        self.actionLabel.editable = false
        
        self.showingMessage = false
        
        super.init(coder: aDecoder)
        
        self.clippingContentView.frame = CGRectMake(0.0, 0.0, 0.0, self.frame.size.height)
        self.addSubview(self.clippingContentView)
        
        self.backgroundColorView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        self.clippingContentView.addSubview(self.backgroundColorView)
        
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor.redColor().CGColor
        self.borderView.backgroundColor = UIColor.clearColor()
        self.borderView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        self.clippingContentView.addSubview(self.borderView)
        
        self.leftBarView.frame = CGRectMake(0.0, 0.0, ImportantActionViewLeftBarWidth, self.frame.size.height)
        self.clippingContentView.addSubview(self.leftBarView)
        
        self.actionLabel.frame = CGRectMake(ImportantActionViewLeftBarWidth + ImportantActionViewTextLeftBuffer, 0.0, self.frame.size.width - (ImportantActionViewLeftBarWidth + ImportantActionViewTextLeftBuffer), self.frame.size.height)
        self.actionLabel.textColor = UIColor.redColor()
        self.clippingContentView.addSubview(self.actionLabel)
    }
    
    func show() {
        self.showingMessage = true
        self.clippingContentView.frame = CGRectMake(0.0, 0.0, ImportantActionViewLeftBarWidth, self.frame.size.height)
        UIView.animateWithDuration(0.4, animations: {
            self.clippingContentView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if showingMessage {
            self.clippingContentView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        }
        else {
            self.clippingContentView.frame = CGRectMake(0.0, 0.0, 0.0, self.frame.size.height)
        }
        self.backgroundColorView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        self.borderView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        self.leftBarView.frame = CGRectMake(0.0, 0.0, ImportantActionViewLeftBarWidth, self.frame.size.height)
        self.actionLabel.frame = CGRectMake(ImportantActionViewLeftBarWidth + ImportantActionViewTextLeftBuffer, 0.0, self.frame.size.width - (ImportantActionViewLeftBarWidth + ImportantActionViewTextLeftBuffer), self.frame.size.height)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
