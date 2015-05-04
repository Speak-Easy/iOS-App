//
//  ShowRestaurantDetailsTableViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/16/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class RestaurantDetailsTableViewController: UITableViewController {

    var restaurantName:String!
    var restaurantObjectId:String!
    var dealsQuery = PFQuery(className: Constants.Deals.ClassName)
    var deals = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.userInteractionEnabled = false
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading Deals"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.algorithmsGreen()
        self.refreshControl?.addTarget(self, action: "getLatestDeals:", forControlEvents: UIControlEvents.ValueChanged)

        self.title = restaurantName
        dealsQuery.whereKey(Constants.Deals.Restaurant, equalTo: restaurantObjectId)
        dealsQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if let error = error {
                println(error.localizedDescription)
            }
            if let dealsResults = results as? [PFObject] {
                self.deals = dealsResults
                self.tableView.reloadData()
            }
            hud.hide(true)
            self.view.userInteractionEnabled = true
        }
    }
    
    func getLatestDeals(sender:AnyObject!) {
        self.refreshControl?.endRefreshing()
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
        return deals.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cost | Information"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        var information = deals[indexPath.row][Constants.Deals.Information] as! String
        var cost = deals[indexPath.row][Constants.Deals.Cost] as! Int
        cell.textLabel?.text = "\(cost)"
        cell.detailTextLabel?.text = information

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
