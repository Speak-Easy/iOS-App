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
    
    let permissionsArray = ["email", "public_profile", "user_friends", "user_about_me", "user_relationships", "user_birthday", "user_location"]
    let LogoutText = "Logout"
    let LoginText = "Login with Facebook"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = PFUser.currentUser() {
           logInButton.setTitle(LogoutText, forState: UIControlState.Normal)
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
            logInButton.setTitle(LoginText, forState: UIControlState.Normal)
        }
        else {
            self.view.userInteractionEnabled = false
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Logging In"
            
            PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user: PFUser?, error:NSError?) -> Void in
                if let existingError = error {
                    println(existingError.description)
                }
                else {
                    if PFUser.currentUser()!.objectForKey(Constants.UserKey.TotalRewards) == nil {
                        PFUser.currentUser()!.setObject(0, forKey: Constants.UserKey.TotalRewards)
                        PFUser.currentUser()!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                            if let existingError = error {
                                println(existingError.description)
                            }
                        })
                    }
                    self.closeButton.enabled = false
                    self.logInButton.setTitle(self.LogoutText, forState: UIControlState.Normal)
                    self.dismissViewControllerAnimated(true, completion: {})
                }
                hud.hide(true)
                self.view.userInteractionEnabled = true
            })
        }
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
