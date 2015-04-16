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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = PFUser.currentUser() {
           logInButton.setTitle("Logout", forState: UIControlState.Normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeLoginViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginWithFacebook() {
        if let user = PFUser.currentUser() {
            closeButton.enabled = false
            PFUser.logOut()
            logInButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
        }
        else {
            self.view.userInteractionEnabled = false
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Logging In"
            
            var permissionsArray = ["email", "public_profile", "user_friends", "user_about_me", "user_relationships", "user_birthday", "user_location"]
            PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user: PFUser?, error:NSError?) -> Void in
                if let existingError = error {
                    println(existingError.description)
                }
                else {
                    self.closeButton.enabled = false
                    self.logInButton.setTitle("Logout", forState: UIControlState.Normal)
                    self.dismissViewControllerAnimated(true, completion: {})
                }
                hud.hide(true)
                self.view.userInteractionEnabled = true
            })
        }
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
