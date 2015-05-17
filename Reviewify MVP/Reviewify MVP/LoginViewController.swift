//
//  LoginViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var logInButton:UIButton!
    @IBOutlet var closeButton: UIBarButtonItem!
    @IBOutlet var myMealsButton: UIBarButtonItem!
    @IBOutlet var pointsLabel: UILabel!
    
    let permissionsArray = ["email", "public_profile", "user_friends", "user_birthday"]
    let LogoutText = "Logout"
    let LoginText = "Login with Facebook"
    let LoggingInText = "Logging In"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = PFUser.currentUser() {
           logInButton.setTitle(LogoutText, forState: UIControlState.Normal)
        }
        else {
            closeButton.enabled = false
            myMealsButton.enabled = false
            pointsLabel.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        downloadPoints()
    }
    
    func downloadPoints() {
        if let user = PFUser.currentUser() {
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Downloading Total Rewards"
            var pointsQuery = PFQuery(className: Constants.Points.ClassName)
            pointsQuery.whereKey(Constants.Points.Username, equalTo: user.username!)
            pointsQuery.getFirstObjectInBackgroundWithBlock({ (pointsObject, error) -> Void in
                if let error = error {
                    if error.code == 101 {
                        
                    }
                    else {
                        self.showAlert("Error", message: "There was a problem downloading your rewards.")
                    }
                }
                else {
                    if let points = pointsObject?[Constants.Points.Total] as? Int {
                        self.pointsLabel.text = "Total Rewards: \(points)"
                        self.pointsLabel.hidden = false
                    }
                }
                hud.hide(true)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeLoginViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginWithFacebook() {
        if let user = PFUser.currentUser() {
            closeButton.enabled = false
            myMealsButton.enabled = false
            PFUser.logOut()
            logInButton.setTitle(LoginText, forState: UIControlState.Normal)
            pointsLabel.hidden = true
        }
        else {
            self.view.userInteractionEnabled = false
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = LoggingInText
            
            PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user: PFUser?, error:NSError?) -> Void in
                if let existingError = error {
                    self.showAlert("Error", message: "There was a problem when attempting to log in with Facebook.")
                }
                else if user != nil {
                    self.closeButton.enabled = false
                    self.myMealsButton.enabled = false
                    self.logInButton.setTitle(self.LogoutText, forState: UIControlState.Normal)
                    self.dismissViewControllerAnimated(true, completion: {})
                }
                hud.hide(true)
                self.view.userInteractionEnabled = true
            })
        }
    }
    
    func showAlert(titles:String!, message:String!) {
        var alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    @IBAction func showMeals(sender:AnyObject!) {
        performSegueWithIdentifier("ShowMealsSegueIdentifier", sender: self)
    }
    
    @IBAction func removeKeyboard(sender:AnyObject!) {
        self.resignFirstResponder()
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
