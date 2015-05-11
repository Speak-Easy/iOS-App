//
//  PurchasedItemListTableViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class RewardsDetailsTableViewController: UITableViewController {
    
    var QRCode:String!
    var restaurantCode:String!
    var mealCode:String!
    var server:String!
    var serverName:String!
    var potentialReward:Int!
    
    let serverRowIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    let missingServerString = "Server Not Found"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        var splitQRCode = QRCode.componentsSeparatedByString(" ")
        if splitQRCode.count == 4 {
            restaurantCode = splitQRCode[0]
            mealCode = splitQRCode[1]
            server = splitQRCode[2]
            potentialReward = splitQRCode[3].toInt()
            
            var query = PFQuery(className: Constants.Servers.ClassName)
            query.whereKey(Constants.Servers.ObjectId, equalTo: self.server)
            query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                if let error = error {
                    println(error.localizedDescription)
                }
                if let server = object {
                    self.serverName = server[Constants.Servers.FirstName] as! String
                    self.tableView.reloadRowsAtIndexPaths([self.serverRowIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                else {
                    self.serverName = self.missingServerString
                }
            })
        }
        else {
            showAlert("Invalid QR Code", message: "If this problem persists, try updating the app.")
        }
    }
    
    func showAlert(title:String!, message:String?) {
        var alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func beginReview(sender: AnyObject) {
        performSegueWithIdentifier("BeginReviewSegueIdentifier", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            println("Invalid Section (\(section)) in func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int in RewardsDetailsTableViewController")
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemListReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.textColor = (UIApplication.sharedApplication().delegate as! AppDelegate).window!.tintColor
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Server Name:"
            cell.detailTextLabel?.text = serverName
        case 1:
            cell.textLabel?.text = "Potential Points:"
            cell.detailTextLabel?.text = "\(potentialReward)"
        default:
            println("Invalid Section (\(indexPath.section)) in func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell in RewardsDetailsTableViewController")
        }

        return cell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "BeginReviewSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as! ReviewViewController
            destinationViewController.restaurantCode = restaurantCode
            destinationViewController.mealCode = mealCode
            destinationViewController.server = server
            destinationViewController.potentialReward = potentialReward
        }
    }

}
