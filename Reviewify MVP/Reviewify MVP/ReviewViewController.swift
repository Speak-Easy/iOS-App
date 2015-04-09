//
//  ReviewViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 2/24/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit
import Foundation

class ReviewViewController: UIViewController, UITextViewDelegate {

    let placeholderText = "Leave any comments here"
    
    var restaurant:String!
    var reward:Double!
    
    @IBOutlet var feedbackTextView: UITextView!
    @IBOutlet var starView: ASStarRatingView!
    
    @IBAction func donePressed(sender: AnyObject) {
        
        var restaurantReview = PFObject(className: restaurant.stripNonAlphanumeric())
        
        restaurantReview.setObject(feedbackTextView.text, forKey: "review")
        restaurantReview.setObject(String(Int(starView.rating)), forKey: "star_rating")
        restaurantReview.setObject(reward, forKey: "reward")
        // restaurantReview["user"] = PFUser.currentUser().email
        
        restaurantReview.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                var navigationController = self.navigationController!
                navigationController.popToRootViewControllerAnimated(true)
                
                var rewardAsString = self.reward.format(".2")
                
                var notification = CWStatusBarNotification()
                notification.notificationLabelBackgroundColor = UIColor.algorithmsGreen()
                notification.notificationLabelTextColor = UIColor.whiteColor()
                notification.notificationStyle = CWNotificationStyle.NavigationBarNotification
                notification.displayNotificationWithMessage("You've been rewarded $\(rewardAsString)! You have $____.__ total rewards!", forDuration: 4.0)
            }
            else {
                println("\(error!.description)")
            }
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        feedbackTextView.text = placeholderText
        feedbackTextView.textColor = UIColor.lightGrayColor()
        feedbackTextView.delegate = self
        
        starView.canEdit = true;
        starView.maxRating = 5;
        starView.minAllowedRating = 1;
        starView.maxAllowedRating = 5;
        starView.rating = 0;
        
        self.title = restaurant
        
        self.navigationController?.navigationBarHidden = false
        
        self.view.addSubview(starView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if feedbackTextView.textColor == UIColor.lightGrayColor() {
            feedbackTextView.text = ""
            feedbackTextView.textColor = UIColor.blackColor()
        }
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if count(feedbackTextView.text) == 0 {
            feedbackTextView.text = placeholderText
            feedbackTextView.textColor = UIColor.lightGrayColor()
        }
        return true
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
