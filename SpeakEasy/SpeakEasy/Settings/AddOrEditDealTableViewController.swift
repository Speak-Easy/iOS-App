//
//  AddOrEditDealTableViewController.swift
//  SpeakEasy
//
//  Created by Bryce Langlotz on 5/1/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class AddOrEditDealTableViewController: UITableViewController {

    var deal:PFObject?
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        var informationCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TextFieldTableViewCell
        var costCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TextFieldTableViewCell
        
        var information = informationCell.textField.text
        var cost = costCell.textField.text
        
        if information == "" || cost == "" {
            showAlert("All fields are required to save.")
        }
        else {
            if deal == nil {
                deal = PFObject(className: "Deals")
            }
            deal!["information"] = information
            deal!["cost"] = cost.toInt()
            deal!["restaurant_objectId"] = PFUser.currentUser()!.objectId
            deal!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if let error = error {
                    self.showAlert(error.localizedDescription)
                }
                else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    func showAlert(message:String!) {
        var alertView = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddOrEditDealCellReuseIdentifier", forIndexPath: indexPath) as! TextFieldTableViewCell

        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "Information"
        case 1:
            cell.textField.placeholder = "Cost (In Points)"
            cell.textField.keyboardType = UIKeyboardType.NumberPad
        default:
            println("Too Many Cells")
        }
        
        if let dealData = deal {
            switch indexPath.row {
            case 0:
                cell.textField.text = dealData["information"] as! String
            case 1:
                var cost = dealData["cost"] as! Int
                cell.textField.text = "\(cost)"
            default:
                println("Too Many Cells")
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
