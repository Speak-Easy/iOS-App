//
//  ReviewTableViewController.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/11/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController, StarRatingTableViewCellDelegate, TextViewTableViewCellDelegate {

    let placeholderText = "Leave any additional comments here (Optional)"
    let loadingText = "Loading Review Form"
    let validatingMealText = "Validating Review"
    
    var restaurantCode:String!
    var mealCode:String!
    var server:String!
    var potentialReward:Int!
    var validationQuery:PFQuery!
    var validMeal:PFObject!
    
    
    var sectionHeaders:[String]! = []
    var starRatings:[Float]! = []
    var textReviews:[String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadForm()
        
        tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if contains(starRatings, 0.00) {
            showAlert("All Star Ratings are required")
        }
        else {
            var hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
            hud.labelText = validatingMealText
            
            PFCloud.reviewRestaurantInBackground(restaurantCode, mealCode: mealCode, potentialReward: potentialReward, currentUsername: PFUser.currentUser()!.username) { (results, error) -> Void in
                hud.hide(true)
                if let error = error {
                    println(error.description)
                    if let alertMessage = error.userInfo?["error"] as? String {
                        self.showAlert(alertMessage)
                    }
                }
                if let totalRewards = results as? Int {
                    
                    Review(restaurant: self.restaurantCode, mealCode: self.mealCode, reviews: self.textReviews, stars: self.starRatings, reward: self.potentialReward)
                    
                    var navigationController = self.navigationController!
                    navigationController.popToRootViewControllerAnimated(true)
                    
                    var notification = CWStatusBarNotification()
                    notification.notificationLabelBackgroundColor = UIColor.algorithmsGreen()
                    notification.notificationLabelTextColor = UIColor.whiteColor()
                    notification.notificationStyle = CWNotificationStyle.NavigationBarNotification
                    
                    notification.displayNotificationWithMessage("You've been rewarded \(self.potentialReward)! You have \(totalRewards) total points!", forDuration: 4.0)
                }
            }
        }
    }
    
    func showAlert(message:String!) {
        var alertView = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func loadForm() {
        var hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        hud.labelText = loadingText
        
        var query = PFQuery(className: "Form")
        query.getFirstObjectInBackgroundWithBlock { (form, error) -> Void in
            if let error = error {
                println("There was a problem loading the form. Try again?")
            }
            if let formDetails = form?["sections"] as? [String] {
                self.sectionHeaders = formDetails
                self.starRatings = [Float](count: formDetails.count, repeatedValue: 0.0)
                self.textReviews = [String](count: formDetails.count, repeatedValue: "")
                self.tableView.reloadData()
            }
            hud.hide(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionHeaders.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 50
        case 1:
            return 100
        default:
            println("Invalid Row Number")
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            var cell = tableView.dequeueReusableCellWithIdentifier("StarRatingTableViewCellReuseIdentifier", forIndexPath: indexPath) as! StarRatingTableViewCell
            cell.tag = indexPath.section
            cell.starRatingView.rating = starRatings[indexPath.section]
            cell.starRatingView.delegate = cell
            cell.starRatingView.minAllowedRating = 0.5
            cell.starRatingView.maxAllowedRating = 5.0
            cell.delegate = self
            return cell
        case 1:
            var cell = tableView.dequeueReusableCellWithIdentifier("TextViewTableViewCellReuseIdentifier", forIndexPath: indexPath) as! TextViewTableViewCell
            cell.tag = indexPath.section
            cell.reviewTextView.text = textReviews[indexPath.section]
            cell.reviewTextView.delegate = cell
            cell.addDoneButtonOnKeyboard()
            cell.delegate = self
            return cell
        default:
            println("Invalid Row Number")
        }

        return UITableViewCell()
    }
    
    func starRatingDidChange(rating: Float!, sender: StarRatingTableViewCell!) {
        starRatings[sender.tag] = rating
    }
    
    func reviewTextDidChange(text: String!, sender: TextViewTableViewCell) {
        textReviews[sender.tag] = text
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
