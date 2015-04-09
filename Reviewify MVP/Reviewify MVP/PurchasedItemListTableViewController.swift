//
//  PurchasedItemListTableViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class PurchasedItemListTableViewController: UITableViewController {
    
    var itemList = [String]()
    var totalLine = ""
    var location = ""
    var totalPrice = 0.00
    var potentialReward = 0.00

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Summary"
        
        self.navigationController?.navigationBarHidden = false

        var components:[String] = totalLine.componentsSeparatedByString(" ")
        totalPrice = (components[components.count - 1] as NSString!).doubleValue
        potentialReward = totalPrice * 0.1
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0:
            return itemList.count
        case 1:
            return 1
        default:
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemListReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        cell.detailTextLabel?.textColor = UIColor.redColor()
        
        switch indexPath.section {
        case 0:
            var components:[String] = itemList[indexPath.row].componentsSeparatedByString(" ")
            var price = components.removeAtIndex(components.count - 1)
            var itemName = " ".join(components)
            
            cell.textLabel?.text = itemName
            cell.detailTextLabel?.text = "$" + price
        case 1:
            var totalPriceAsString = totalPrice.format(".2")
            
            cell.textLabel?.text = "Total:"
            cell.detailTextLabel?.text = "$\(totalPriceAsString)"
        case 2:
            switch indexPath.row {
            case 0:
                var rewardAsString = potentialReward.format(".2")
                
                cell.textLabel?.text = "Potential Reward (10%)"
                cell.detailTextLabel?.text = "$\(rewardAsString)"
                cell.detailTextLabel?.textColor = UIColor.algorithmsGreen()
            default:
                println("Error in section 3")
            }
        default:
            println("No Section 4")
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
            destinationViewController.restaurant = location
            destinationViewController.reward = potentialReward
        }
        
    }

}
