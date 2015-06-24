//
//  LoginViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var logInButton:UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var reenterPasswordTextField: UITextField!
    @IBOutlet var actionView: ImportantInformationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFUser.logOut()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "removeKeyboard:"))
        
        self.reenterPasswordTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    @IBAction func textFieldDidChange(sender:AnyObject!) {
        if reenterPasswordTextField.text == "" {
            logInButton.setTitle("Login", forState: UIControlState.Normal)
        }
        else {
            logInButton.setTitle("Sign Up", forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: AnyObject) {
        self.removeKeyboard(self)
        var lowercaseEmail = (self.emailTextField.text as NSString).lowercaseString
        if reenterPasswordTextField.text == "" {
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = "Logging In"
            PFUser.logInWithUsernameInBackground(lowercaseEmail, password: self.passwordTextField.text, block: { (user, error) -> Void in
                if let error = error {
                    if error.code == 101 {
                        self.actionView.actionLabel.text = "● Invalid login credentials"
                        self.actionView.show()
                    }
                }
                else {
                    var emailVerified:Bool = user?.valueForKey("emailVerified") as! Bool
                    if emailVerified {
                        self.removeKeyboard(self)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else {
                        self.actionView.actionLabel.text = "● Verify E-Mail and try again"
                        self.actionView.show()
                        PFUser.logOut()
                    }
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
        }
        else if self.reenterPasswordTextField.text == self.passwordTextField.text && self.passwordTextField.text != "" {
            if count(self.passwordTextField.text) < 5 || count(self.passwordTextField.text) > 16 {
                self.actionView.actionLabel.text = "● Password must be 5-16 characters"
                self.actionView.show()
            }
            else {
                var user = PFUser()
                user.username = lowercaseEmail
                user.password = self.passwordTextField.text
                user.email = user.username
                
                var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Indeterminate
                hud.labelText = "Creating User"
                user.signUpInBackgroundWithBlock {
                    (succeeded, error) -> Void in
                    if error == nil {
                        self.reenterPasswordTextField.text = ""
                        self.actionView.actionLabel.text = "● Verify E-Mail before logging in"
                        self.actionView.show()
                        PFUser.logOut()
                        self.logInButton.setTitle("Login", forState: UIControlState.Normal)
                    }
                    if let error = error {
                        if error.code == 202 || error.code == 203 {
                            self.actionView.actionLabel.text = "● E-Mail is already registered"
                            
                            self.actionView.show()
                        }
                        if error.code == 125 {
                            self.actionView.actionLabel.text = "● Invalid E-Mail"
                            self.actionView.show()
                        }
                    }
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }
        }
        if self.reenterPasswordTextField.text != "" && self.passwordTextField.text != self.reenterPasswordTextField.text {
            self.actionView.actionLabel.text = "● Passwords don't match"
            self.actionView.show()
        }
    }
    
    func showAlert(titles:String!, message:String!) {
        var alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    @IBAction func removeKeyboard(sender: AnyObject) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.reenterPasswordTextField.resignFirstResponder()
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
