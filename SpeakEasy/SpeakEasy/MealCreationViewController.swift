//
//  ViewController.swift
//  SpeakEasy: Restaurant
//
//  Created by Bryce Langlotz on 4/23/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class MealCreationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var pointsTextField: UITextField!
    @IBOutlet var serverTextField: UITextField!
    @IBOutlet var QRCodeImageView: UIImageView!
    
    var mealObjectId: String!
    var QRCodeString: String!

    @IBAction func settingsPressed(sender: AnyObject) {
        performSegueWithIdentifier("ShowRestaurantOptionsSegueIdentifier", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        PFUser.logOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sizeQRCodeView()
        
        if let user = PFUser.currentUser() {
            PFUser.currentUser()?.isRestaurant({ (success, error) -> Void in
                if let error = error {
                    println(error.description)
                    self.performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
                }
            })
        }
        else {
            performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
        }
    }
    
    func sizeQRCodeView() {
        var frame = QRCodeImageView.frame
        var originDistanceFromBottom = self.view.bounds.size.height - frame.origin.y - (frame.origin.x)
        var originDistanceFromSide = self.view.bounds.size.width - frame.origin.x - (frame.origin.x)
        var sideLength = min(originDistanceFromBottom, originDistanceFromSide)
        frame.size = CGSizeMake(sideLength, sideLength)
        QRCodeImageView.frame = frame
    }
    
    @IBAction func logout(sender:AnyObject) {
        performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
    }
    
    @IBAction func generate(sender: AnyObject) {
        var newMeal = PFObject(className: "Meals")
        newMeal["claimed"] = false
        newMeal["restaurant_objectId"] = PFUser.currentUser()?.objectId
        newMeal["claimed_by"] = ""
        newMeal["server_objectId"] = serverTextField.text
        newMeal["potential_reward"] = pointsTextField.text.toInt()!
        
        newMeal.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.mealObjectId = newMeal.objectId!
                self.generateQRCode()
            }
            if let error = error {
                println(error.description)
            }
        }
        
        var newServer = PFObject(className: "Servers")
        newServer.setValue("Bryce", forKey: "first_name")
        newServer.setValue("Langlotz", forKey: "last_name")
        newServer.setValue("brycel@vt.edu", forKey: "email")
        newServer.setValue(PFUser.currentUser()!.objectId!, forKey: "restaurant_objectId")
        newServer.saveInBackgroundWithBlock { (success, error) -> Void in
            if let error = error {
                println(error.description)
            }
        }
        
        var newDeal = PFObject(className: "Deals")
        newDeal.setValue("Test Deal", forKey: "information")
        newDeal.setValue(100, forKey: "cost")
        newDeal.setValue(PFUser.currentUser()!.objectId!, forKey: "restaurant_objectId")
        newDeal.saveInBackgroundWithBlock { (success, error) -> Void in
            if let error = error {
                println(error.description)
            }
        }
    }
    
    func generateQRCode() {
        var error:NSError?
        
        var writer:ZXMultiFormatWriter = ZXMultiFormatWriter()
        var restaurantCode = PFUser.currentUser()!.objectId!
        QRCodeString = restaurantCode + " " + mealObjectId + " " + serverTextField.text + " " + pointsTextField.text
        var width:Int32 = Int32(QRCodeImageView.frame.size.width)
        var height:Int32 = Int32(QRCodeImageView.frame.size.height)
        var result = writer.encode(QRCodeString, format: kBarcodeFormatQRCode, width: width, height: height, error: &error)
        
        if let error = error {
            println(error.localizedDescription)
        }
        else {
            var image = UIImage(CGImage: ZXImage(matrix: result).cgimage)
            QRCodeImageView.image = image
        }
    }
}

