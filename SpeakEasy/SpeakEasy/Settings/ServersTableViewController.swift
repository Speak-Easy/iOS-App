//
//  ServersTableViewController.swift
//  SpeakEasy: Restaurant
//
//  Created by Bryce Langlotz on 4/23/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class ServersTableViewController: UITableViewController {
    
    var serverQuery = PFQuery(className: "Servers")
    var dealsQuery = PFQuery(className: "Deals")
    
    var servers = [PFObject]()
    var deals = [PFObject]()
    var selectedServer:PFObject?
    var selectedDeal:PFObject?
    
    @IBAction func addServer(sender: AnyObject) {
        // performSegueWithIdentifier("AddServerSegueIdentifier", sender: self)
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedServer = nil
        selectedDeal = nil
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading Servers"
        
        serverQuery.whereKey("restaurant_objectId", equalTo: PFUser.currentUser()!.objectId!)
        dealsQuery.whereKey("restaurant_objectId", equalTo: PFUser.currentUser()!.objectId!)
        
        serverQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if let error = error {
                println(error.localizedDescription)
                hud.hide(true)
            }
            else {
                if let serversResults = results as? [PFObject] {
                    self.servers = serversResults
                    self.tableView.reloadData()
                    hud.labelText = "Loading Deals"
                    self.dealsQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
                        if let error = error {
                            println(error.localizedDescription)
                        }
                        else {
                            if let dealsResults = results as? [PFObject] {
                                self.deals = dealsResults
                                self.deals.sort({($0["cost"] as! Int) < ($1["cost"] as! Int)})
                                self.tableView.reloadData()
                            }
                        }
                        hud.hide(true)
                    }
                }
            }
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
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Servers"
        case 1:
            return "Deals"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0:
            return servers.count + 1
        case 1:
            return deals.count + 1
        default:
            return 0
            
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var serversCount = servers.count
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0..<serversCount:
                let cell = tableView.dequeueReusableCellWithIdentifier("ServerCellReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
                
                let server = servers[indexPath.row]
                cell.textLabel?.text = (server["first_name"] as! String) + " " + (server["last_name"] as! String)
                cell.detailTextLabel?.text = server["email"] as? String
                cell.detailTextLabel?.textColor = UIColor.algorithmsGreen()
                
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("AddMoreCellReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
                return cell
            }
        case 1:
            switch indexPath.row {
            case 0..<deals.count:
                let cell = tableView.dequeueReusableCellWithIdentifier("DealCellReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
                
                let deal = deals[indexPath.row]
                var dealCost = deal["cost"] as! Int
                
                cell.textLabel?.text = deal["information"] as? String
                cell.detailTextLabel?.text = "\(dealCost)"
                cell.detailTextLabel?.textColor = UIColor.algorithmsGreen()
                
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("AddMoreCellReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("ServerCellReuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0..<servers.count:
                return true
            default:
                return false
            }
        case 1:
            switch indexPath.row {
            case 0..<deals.count:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0..<servers.count:
                    var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.labelText = "Removing Server"
                    servers[indexPath.row].deleteInBackgroundWithBlock({ (success, error) -> Void in
                        if let error = error {
                            println(error.localizedDescription)
                        }
                        hud.hide(true)
                    })
                    servers.removeAtIndex(indexPath.row)
                default:
                    println("Shouldn't Be Able To Delete Row")
                }
            case 1:
                switch indexPath.row {
                case 0..<deals.count:
                    var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.labelText = "Removing Deal"
                    deals[indexPath.row].deleteInBackgroundWithBlock({ (success, error) -> Void in
                        if let error = error {
                            println(error.localizedDescription)
                        }
                        hud.hide(true)
                    })
                    deals.removeAtIndex(indexPath.row)
                default:
                    println("Shouldn't Be Able To Delete Row")
                }
            default:
                println("Shouldn't Be Able To Delete In Section")
            }

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0..<servers.count:
                selectedServer = servers[indexPath.row]
                performSegueWithIdentifier("AddOrEditServerSegueIdentifier", sender: self)
            default:
                performSegueWithIdentifier("AddOrEditServerSegueIdentifier", sender: self)
            }
        case 1:
            switch indexPath.row {
            case 0..<deals.count:
                selectedDeal = deals[indexPath.row]
                performSegueWithIdentifier("AddOrEditDealSegueIdentifier", sender: self)
            default:
                performSegueWithIdentifier("AddOrEditDealSegueIdentifier", sender: self)
            }
        default:
            println("Shouldn't Be Able To Delete In Section")
        }
    }

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
        if segue.identifier == "AddOrEditServerSegueIdentifier" {
            var destinationViewControllerNavigationController = segue.destinationViewController as! UINavigationController
            var destinationViewController = destinationViewControllerNavigationController.viewControllers[0] as! AddOrEditServerTableViewController
            destinationViewController.server = selectedServer
        }
        if segue.identifier == "AddOrEditDealSegueIdentifier" {
            var destinationViewControllerNavigationController = segue.destinationViewController as! UINavigationController
            var destinationViewController = destinationViewControllerNavigationController.viewControllers[0] as! AddOrEditDealTableViewController
            destinationViewController.deal = selectedDeal
        }
    }

}
