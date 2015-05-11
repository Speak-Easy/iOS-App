//
//  TextViewTableViewCell.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/11/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

protocol TextViewTableViewCellDelegate {
    func reviewTextDidChange(text:String!, sender:TextViewTableViewCell)
}

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var reviewTextView:UITextView!
    
    var delegate:TextViewTableViewCellDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textViewDidChange(textView: UITextView) {
        self.delegate?.reviewTextDidChange(textView.text, sender: self)
    }
    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = items as [AnyObject]
        doneToolbar.sizeToFit()
        
        reviewTextView.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        reviewTextView.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
