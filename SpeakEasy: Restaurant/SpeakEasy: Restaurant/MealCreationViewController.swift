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
    
    var restaurantCode: String! = "TestRestaurant"
    var mealObjectId: String!
    var QRCodeString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sizeQRCodeView()
    }
    
    func sizeQRCodeView() {
        var frame = QRCodeImageView.frame
        var originDistanceFromBottom = self.view.bounds.size.height - frame.origin.y - (frame.origin.x)
        var originDistanceFromSide = self.view.bounds.size.width - frame.origin.x - (frame.origin.x)
        var sideLength = min(originDistanceFromBottom, originDistanceFromSide)
        frame.size = CGSizeMake(sideLength, sideLength)
        QRCodeImageView.frame = frame
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = PFUser.currentUser() {
            if let isRestaurant = user["is_restaurant"] as? Bool {
                if isRestaurant == true {
                    self.performSegueWithIdentifier("ShowRestaurantOptionsSegueIdentifier", sender: self)
                }
            }
        }
        else {
            performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
        }
    }
    
    @IBAction func generate(sender: AnyObject) {
        var newMeal = PFObject(className: "Meals")
        newMeal["claimed"] = false
        newMeal["restaurant"] = restaurantCode
        newMeal["claimed_by"] = ""
        newMeal["server"] = serverTextField.text
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
    }
    
    func generateQRCode() {
        var error:NSError?
        
        var writer:ZXMultiFormatWriter = ZXMultiFormatWriter()
        QRCodeString = restaurantCode + " " + mealObjectId + " " + serverTextField.text + " " + pointsTextField.text
        var width:Int32 = Int32(QRCodeImageView.frame.size.width)
        var height:Int32 = Int32(QRCodeImageView.frame.size.height)
        var result = writer.encode(QRCodeString, format: kBarcodeFormatQRCode, width: width, height: height, error: &error)
        
        if let error = error {
            println(error.localizedDescription)
        }
        else {
            var image = UIImage(CGImage: ZXImage(matrix: result, onColor: UIColor.whiteColor().CGColor, offColor: UIColor.algorithmsGreen().CGColor).cgimage)
            QRCodeImageView.image = image
        }
    }
}

