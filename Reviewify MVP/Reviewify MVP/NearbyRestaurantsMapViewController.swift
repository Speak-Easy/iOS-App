//
//  NearbyRestaurantsMapViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/12/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit
import MapKit

class NearbyRestaurantsMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView:MKMapView!

    var restaurants: [String:CLLocationCoordinate2D] = [:]
    var query = PFQuery(className: "Restaurants")
    var selectedRestaurant:String!
    
    let PinImage = "map_pin_green"
    
    func fetch() {
        self.query.limit = 1000
        self.query.skip = 0
        
        self.query.findObjectsInBackgroundWithBlock(self.closure)
    }
    
    func closure(results:[AnyObject]?, error:NSError?) -> Void {
        if let resultsArray = results {
            for response in resultsArray {
                var restaurant = response as! PFObject
                var name = restaurant[Constants.RestaurantKey.Name] as! String
                if let coordinateAsGeoPoint = restaurant[Constants.RestaurantKey.Location] as? PFGeoPoint {
                    var coordinate = CLLocationCoordinate2D(latitude: coordinateAsGeoPoint.latitude, longitude: coordinateAsGeoPoint.longitude)
                    self.restaurants[name] = coordinate
                }
            }
            if resultsArray.count == 1000 {
                self.query.skip += 1000
                self.query.findObjectsInBackgroundWithBlock(self.closure)
            }
            else {
                self.refreshRestaurants()
            }
        }
        if let existingError = error {
            println(existingError.description)
        }
    }
    
    func refreshRestaurants() {
        var keys = restaurants.keys
        for key in keys {
            var restaurantName = key as String
            if let restaurantCoordinate = restaurants[restaurantName] {
                var annotation = MKPointAnnotation()
                annotation.coordinate = restaurantCoordinate
                annotation.title = restaurantName
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        if let location = locationManager.location?.coordinate {
            mapView.region = MKCoordinateRegionMakeWithDistance(location, 10000, 10000);
        }
        
        fetch()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        var annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
        if annotationView != nil {
            return annotationView
        }
        else {
            var viewWidth:CGFloat = 35.0
            var annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: PinImage)
            annotationView.frame.size = CGSizeMake(viewWidth, (viewWidth / annotationView.frame.size.width) * annotationView.frame.size.height)
            
            var rightButton:UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            rightButton.addTarget(self, action: "selectRestaurant:", forControlEvents: UIControlEvents.TouchUpInside)
            rightButton.setTitle(annotation.title, forState: UIControlState.Normal)
            
            annotationView.rightCalloutAccessoryView = rightButton
            annotationView.canShowCallout = true
            annotationView.draggable = false
            
            annotationView.centerOffset = CGPointMake(0, -annotationView.frame.size.height / 2);
            
            return annotationView
        }
    }
    
    func selectRestaurant(sender:AnyObject!) {
        var button = sender as! UIButton
        var name = button.titleForState(UIControlState.Normal)!
        selectedRestaurant = name
        performSegueWithIdentifier("ShowRestaurantDetailsSegueIdentifier", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowRestaurantDetailsSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as! RestaurantDetailsTableViewController
            destinationViewController.restaurantName = selectedRestaurant
        }
    }

}
