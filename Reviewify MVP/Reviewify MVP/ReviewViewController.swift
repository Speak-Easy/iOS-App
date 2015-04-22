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
    let timeLimitInSeconds:Double = 60 * 60 * 100000000 // 1 Hour (Time Intervals are done in seconds) * a lot for demo purposes
    
    @IBOutlet var feedbackTextView: UITextView!
    @IBOutlet var starView: ASStarRatingView!
    
    @IBAction func donePressed(sender: AnyObject) {
        
        var restaurantReview = PFObject(className: restaurantCode)
        
        restaurantReview.setObject(feedbackTextView.text, forKey: "review")
        restaurantReview.setObject(String(Int(starView.rating)), forKey: "star_rating")
        restaurantReview.setObject(potentialReward, forKey: "reward")
        
        validateMeal { (success) -> () in
            if success {
                restaurantReview.setObject(self.validMeal.objectId!, forKey: "meal")
                restaurantReview.saveInBackgroundWithBlock { (success, error) -> Void in
                    if success {
                        var navigationController = self.navigationController!
                        navigationController.popToRootViewControllerAnimated(true)
                        
                        var notification = CWStatusBarNotification()
                        notification.notificationLabelBackgroundColor = UIColor.algorithmsGreen()
                        notification.notificationLabelTextColor = UIColor.whiteColor()
                        notification.notificationStyle = CWNotificationStyle.StatusBarNotification
                        
                        var totalRewards = PFUser.currentUser()!.objectForKey("total_rewards") as! Int
                        totalRewards += self.potentialReward
                        PFUser.currentUser()!.setObject(totalRewards, forKey: "total_rewards")
                        PFUser.currentUser()!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                            if let existingError = error {
                                println(existingError.description)
                            }
                            else {
                                notification.displayNotificationWithMessage("You've been rewarded \(self.potentialReward)! You have \(totalRewards) total rewards!", forDuration: 4.0)
                            }
                        })
                    }
                    else {
                        println("\(error!.description)")
                    }
                }
            }
            else {
                // Tell user the meal has been claimed
            }
        }
    }
    
    func validateMeal(completion:(success :Bool) ->())
    {
        validationQuery = PFQuery(className: Constants.MealValidation.ClassName)
        validationQuery.whereKey(Constants.MealValidation.MealID, equalTo: mealCode)
        validationQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if let error = error {
                completion(success: false)
                println("Invalid Meals Query")
            }
            else if results!.count == 0 {
                completion(success: false)
                println("Meal Doesn't Exist")
            }
            else {
                var meal = results![0] as! PFObject
                var creationDate = meal.createdAt!
                var timeSinceCreation = -creationDate.timeIntervalSinceNow
                var claimed = meal[Constants.MealValidation.Claimed] as! Bool
                var withinTimeRestraint = (timeSinceCreation as Double) < self.timeLimitInSeconds
                if !claimed && withinTimeRestraint {
                    self.validMeal = meal
                    meal[Constants.MealValidation.Claimed] = true
                    meal[Constants.MealValidation.ClaimedBy] = PFUser.currentUser()!.username
                    meal[Constants.MealValidation.Restaurant] = self.restaurantCode
                    meal.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if success {
                            completion(success: true)
                        }
                        if let error = error{
                            println(error.description)
                        }
                    })
                }
                else {
                    println("Meal Has Been Claimed or Is More Than An Hour Old")
                    completion(success: false)
                }

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
