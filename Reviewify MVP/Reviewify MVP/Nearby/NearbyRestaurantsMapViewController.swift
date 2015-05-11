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

    var restaurants: [String:PFUser] = [:]
    var selectedRestaurant:String!
    var selectedRestaurantObjectId:String!
    var query:PFQuery!
    var locationManager = CLLocationManager()
    
    let PinImage = "map_pin_green"
    
    func fetch() {
        query = PFRole.query()
        
        query.whereKey("name", equalTo: "Restaurant")
        
        query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
            if let error = error {
                println(error.localizedDescription)
            }
            else {
                var role = object as! PFRole
                var userRelation = role.relationForKey("users") as PFRelation
                var userRelationQuery = userRelation.query()!
                
                userRelationQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                    if let error = error {
                        println(error.localizedDescription)
                    }
                    else {
                        var users = results as! [PFUser]!
                        for user in users {
                            if let name = user["restaurant_name"] as? String {
                                self.restaurants[name] = user
                            }
                        }
                        self.refreshRestaurants()
                    }
                })
            }
        })
    }
    
    func refreshRestaurants() {
        var keys = restaurants.keys
        for key in keys {
            var restaurantName = key as String
            if let restaurantObject = restaurants[restaurantName] {
                var annotation = MKPointAnnotation()
                if let coordinateAsGeoPoint = restaurantObject[Constants.Restaurants.Location] as? PFGeoPoint {
                    var coordinate = CLLocationCoordinate2D(latitude: coordinateAsGeoPoint.latitude, longitude: coordinateAsGeoPoint.longitude)
                    annotation.coordinate = coordinate
                    annotation.title = restaurantName
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        var annotationViews = views as! [MKAnnotationView]
        for annotationView:MKAnnotationView in annotationViews {
            if annotationView.annotation.isKindOfClass(MKUserLocation) {

            }
            else {
                var endFrame = annotationView.frame
                
                annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - self.view.bounds.size.height, annotationView.frame.size.width, annotationView.frame.size.height)
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.45)
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                annotationView.frame = endFrame
                UIView.commitAnimations()
            }
        }
    }
    
    func selectRestaurant(sender:AnyObject!) {
        var button = sender as! UIButton
        var name = button.titleForState(UIControlState.Normal)!
        selectedRestaurant = name
        selectedRestaurantObjectId = restaurants[selectedRestaurant]?.objectId
        performSegueWithIdentifier("ShowRestaurantDetailsSegueIdentifier", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowRestaurantDetailsSegueIdentifier" {
            var destinationViewController = segue.destinationViewController as! RestaurantDetailsTableViewController
            destinationViewController.restaurantName = selectedRestaurant
            if let deals = selectedRestaurantObjectId{
                destinationViewController.restaurantObjectId = selectedRestaurantObjectId
            }
        }
    }

}
