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
    
    var restaurantCode:String!
    var mealCode:String!
    var server:String!
    var potentialReward:Int!
    var validationQuery:PFQuery!
    var validMeal:PFObject!
    
    @IBOutlet var feedbackTextView: UITextView!
    @IBOutlet var starView: ASStarRatingView!
    
    @IBAction func donePressed(sender: AnyObject) {
        
        PFCloud.reviewRestaurantInBackground(restaurantCode, mealCode: mealCode, potentialReward: potentialReward, review: feedbackTextView.text, starRating: starView.rating, currentUsername: PFUser.currentUser()!.username) { (results, error) -> Void in
            if let error = error {
                println(error.description)
                if let alertMessage = error.userInfo?["error"] as? String {
                    self.showAlert(alertMessage)
                }
            }
            if let totalRewards = results as? Int {
                
                Review(restaurant: self.restaurantCode, mealCode: self.mealCode, reviewText: self.feedbackTextView.text, rating: self.starView.rating, reward: self.potentialReward)
                
                var navigationController = self.navigationController!
                navigationController.popToRootViewControllerAnimated(true)
                
                var notification = CWStatusBarNotification()
                notification.notificationLabelBackgroundColor = UIColor.algorithmsGreen()
                notification.notificationLabelTextColor = UIColor.whiteColor()
                notification.notificationStyle = CWNotificationStyle.NavigationBarNotification
                
                notification.displayNotificationWithMessage("You've been rewarded \(self.potentialReward)! You have \(totalRewards) total rewards!", forDuration: 4.0)
            }
        }
    }
    
    func showAlert(message:String!) {
        var alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
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
        
        starView.canEdit = true
        starView.maxRating = 5
        starView.minAllowedRating = 0.5
        starView.maxAllowedRating = 5
        starView.rating = 5
        
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
