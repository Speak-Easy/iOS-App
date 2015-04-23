//
//  LoginViewController.swift
//  SpeakEasy: Restaurant
//
//  Created by Bryce Langlotz on 4/23/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func login(sender:AnyObject!) {
        PFUser.logInWithUsernameInBackground(emailTextField.text, password: passwordTextField.text) { (user, error) -> Void in
            if let error = error {
                println(error.localizedDescription)
            }
            else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
