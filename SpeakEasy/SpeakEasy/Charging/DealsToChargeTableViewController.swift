//
//  DeaslToChargeTableViewController.swift
//  SpeakEasy
//
//  Created by Bryce Langlotz on 5/4/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class DealsToChargeTableViewController: UITableViewController {

    var dealsQuery = PFQuery(className: "Deals")
    var deals = [PFObject]()
    var selectedDeal:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.algorithmsGreen()
        self.refreshControl?.addTarget(self, action: "getLatestDeals:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl?.beginRefreshing()
        
        getLatestDeals(nil)
    }
    
    func getLatestDeals(sender:AnyObject!) {
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Downloading Deals"
        dealsQuery.whereKey("restaurant_objectId", equalTo: PFUser.currentUser()!.objectId!)
        dealsQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if let error = error {
                println(error.localizedDescription)
            }
            if let dealsResults = results as? [PFObject] {
                self.deals = dealsResults
                self.deals.sort{($0["cost"] as! Int) < ($1["cost"] as! Int)}
                self.tableView.reloadData()
            }
            hud.hide(true)
            self.refreshControl?.endRefreshing()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return deals.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DealToChargeCellReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if indexPath.row == deals.count {
            cell.textLabel?.text = "..."
            cell.textLabel?.textColor = UIColor.algorithmsGreen()
            
            cell.detailTextLabel?.text = "Manually Enter Point Value"
        }
        else {
            var deal = deals[indexPath.row]
            var cost = deal["cost"] as! Int
            cell.textLabel?.text = "\(cost)"
            cell.textLabel?.textColor = UIColor.algorithmsGreen()
            
            cell.detailTextLabel?.text = deal["information"] as? String
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < deals.count {
            selectedDeal = deals[indexPath.row]
        }
        performSegueWithIdentifier("ChargeItemViewControllerSegueIdentifier", sender: self)
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
        if segue.identifier == "ChargeItemViewControllerSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as! ChargingViewController
            destinationViewController.deal = selectedDeal
        }
    }
}
