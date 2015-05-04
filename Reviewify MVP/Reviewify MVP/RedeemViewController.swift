//
//  RedeemViewController.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/3/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class RedeemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var pointsTextField:UITextField!
    
    var qrCodeImageView = QRCodeImageView()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "removeKeyboard:"))
        pointsTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(qrCodeImageView)
        qrCodeImageView.frame.origin = CGPointZero
        sizeQRCodeView()
        qrCodeImageView.qrCodeString = PFUser.currentUser()!.username!
        pointsTextField.text = ""
        qrCodeImageView.alpha = 0.05
        
        // Do any additional setup after loading the view.
    }
    
    func removeKeyboard(sender:AnyObject!) {
        pointsTextField.resignFirstResponder()
    }
    
    func sizeQRCodeView() {
        var frame = qrCodeImageView.frame
        var originDistanceFromBottom = self.view.bounds.size.height - frame.origin.y - (frame.origin.x)
        var originDistanceFromSide = self.view.bounds.size.width - frame.origin.x - (frame.origin.x)
        var sideLength = min(originDistanceFromBottom, originDistanceFromSide)
        frame.size = CGSizeMake(sideLength, sideLength)
        qrCodeImageView.frame = frame
        
        qrCodeImageView.center = self.view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if count(textField.text) == 7 && string != "" {
            return false
        }
        else if textField.text == "" && string.toInt() == 0 {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var frame = qrCodeImageView.frame
        frame.origin = CGPointMake(frame.origin.x, self.pointsTextField.frame.origin.y + self.pointsTextField.frame.size.height + 10.0)
        UIView.animateWithDuration(0.2, animations: {
            self.qrCodeImageView.frame = frame
        })
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2, animations: {
            self.qrCodeImageView.center = self.view.center
        })
    }
    
    func textFieldDidChange(sender: AnyObject!) {
        var textField = sender as! UITextField
        if textField.text != "" {
            var points = ("".join(textField.text.componentsSeparatedByString(","))).toInt()!
            if points >= 1000 {
                var afterComma = String(format: "%03d", points % 1000)
                textField.text = "\(points / 1000),\(afterComma)"
            }
            else {
                textField.text = "\(points)"
            }
            qrCodeImageView.qrCodeString = PFUser.currentUser()!.username! + " " + "\(points)"
            UIView.animateWithDuration(0.2, animations: {
                self.qrCodeImageView.alpha = 1.0
            })
        }
        else {
            qrCodeImageView.qrCodeString = PFUser.currentUser()!.username!
            UIView.animateWithDuration(0.2, animations: {
                self.qrCodeImageView.alpha = 0.05
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
