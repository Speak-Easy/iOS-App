//
//  AddOrEditServerTableViewController.swift
//  
//
//  Created by Bryce Langlotz on 5/1/15.
//
//

import UIKit

class AddOrEditServerTableViewController: UITableViewController {

    var server:PFObject?
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        var firstNameCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TextFieldTableViewCell
        var lastNameCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TextFieldTableViewCell
        var emailCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! TextFieldTableViewCell
        
        var firstName = firstNameCell.textField.text
        var lastName = lastNameCell.textField.text
        var email = emailCell.textField.text
        
        if firstName == "" || lastName == "" || email == "" {
            showAlert("All fields are required to save.")
        }
        else {
            if server == nil {
                server = PFObject(className: "Servers")
            }
            server!["first_name"] = firstName
            server!["last_name"] = lastName
            server!["email"] = email
            server!["restaurant_objectId"] = PFUser.currentUser()!.objectId
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Loading Servers"
            server?.saveInBackgroundWithBlock({ (success, error) -> Void in
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
        
        if let serverData = server {
            self.title = (serverData["first_name"] as! String) + " " + (serverData["last_name"] as! String)
        }
        else {
            self.title = "New Server"
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
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddOrEditServerCellReuseIdentifier", forIndexPath: indexPath) as! TextFieldTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "First Name"
        case 1:
            cell.textField.placeholder = "Last Name"
        case 2:
            cell.textField.placeholder = "E-Mail"
            cell.textField.keyboardType = UIKeyboardType.EmailAddress
        default:
            println("Too Many Cells")
        }

        if let serverData = server {
            switch indexPath.row {
            case 0:
                cell.textField.text = serverData["first_name"] as! String
            case 1:
                cell.textField.text = serverData["last_name"] as! String
            case 2:
                cell.textField.text = serverData["email"] as! String
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
