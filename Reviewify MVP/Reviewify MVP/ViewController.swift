//
//  ViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 2/24/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let beginButtonTitle = "Begin Review"
    
    var restaurants: [String] = []
    var query = PFQuery(className: "Restaurants")
    
    @IBOutlet var restaurantPicker: UIPickerView!
    @IBOutlet var beginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        beginButton.layer.cornerRadius = 4.0
        beginButton.layer.backgroundColor = UIColor.algorithmsGreen().CGColor
        beginButton.setTitle(beginButtonTitle, forState: UIControlState.Normal)
        beginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: DataMethods
    
    func fetch() {
        
        restaurants = []
        
        self.query.limit = 1000
        self.query.skip = 0
        
        self.query.findObjectsInBackgroundWithBlock(self.closure)
    }
    
    func closure(results:[AnyObject]!, error:NSError!) -> Void {
        if error == nil {
            for response in results {
                var restaurant = response as PFObject
                var name = restaurant["name"] as String!
                self.restaurants += [name]
            }
            if results.count == 1000 {
                self.query.skip += 1000
                self.query.findObjectsInBackgroundWithBlock(self.closure)
            }
            else {
                restaurants.sort{$0 < $1}
                restaurantPicker.reloadAllComponents()
            }
        }
        else {
            println(error.description)
        }
    }

    
    // MARK: Button Methods
    
    @IBAction func beginButtonPressed(sender:AnyObject) {
        performSegueWithIdentifier("BeginReviewSegueIdentifier", sender: self)
    }

    // MARK: Picker Methods
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restaurants.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return restaurants[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BeginReviewSegueIdentifier" {
            var destinationViewControllerNavigationController = (segue.destinationViewController as UINavigationController)
            var destinationViewController = destinationViewControllerNavigationController.viewControllers[0] as ReviewViewController
            destinationViewController.restaurant = restaurants[restaurantPicker.selectedRowInComponent(0)]
            destinationViewController.title = restaurants[restaurantPicker.selectedRowInComponent(0)]
        }
    }
}

