//
//  ViewController.swift
//  SafeApp2
//
//  Created by Caitlyn Chen on 6/30/15.
//  Copyright (c) 2015 Caitlyn Chen. All rights reserved.
//

//this project's map and login with parse works


import MapKit
import UIKit
import CoreLocation
import Parse
import ParseUI
import Bond
import FBSDKCoreKit
import FBSDKLoginKit
import Mixpanel

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    let mixpanel = Mixpanel.sharedInstance()
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var annotationCurrent: PinAnnotation?
    
    var fromGeoButton: Bool?
    var geoButtonTitle: String?
    
    var fromLoginViewController: Bool = false
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    var ann: PinAnnotation?
    var annForFlagPost: PinAnnotation?
    var coorForUpdatedPost: CLLocationCoordinate2D?
    
    var updatedPost: PinAnnotation?
    
    @IBOutlet weak var cancelSearchBar: UIButton!
    var points: [PFGeoPoint] = []
    
    var locationManager = CLLocationManager()
    let loginViewController = PFLogInViewController()
    var parseLoginHelper: ParseLoginHelper!
    
    var mapAnnoations: [PinAnnotation] = []
    
    
    private var responseData:NSMutableData?
    private var selectedPointAnnotation:MKPointAnnotation?
    private var connection:NSURLConnection?
    
    private let googleMapsKey = "AIzaSyD8-OfZ21X2QLS1xLzu1CLCfPVmGtch7lo"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if(segue.identifier == "fromPostToMap"){
            
            
        } else if (segue.identifier == "fromPostDiplayToMap") {
            let svc = segue.sourceViewController as! PostDisplayViewController;
            
            if svc.annotation?.post == nil{
                
                svc.createPost()
                self.mixpanel.track("Segue", properties: ["from Post Display to Map View": "Create"])
                
            } else {
                svc.updatePost()
                self.mixpanel.track("Segue", properties: ["from Post Display to Map View": "Update"])
                updatedPost = svc.annotation
                //                svc.coorForUpdatedPost = annotation?.coordinate
            }
            
            
            annotationCurrent = svc.currentAnnotation
            
            
        } else if (segue.identifier == "backButtonToMap"){
            
        }
        
    }
    
    
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            //Do some stuff
            
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            //Do some other stuff
            PFUser.logOut()
            let logoutNotification: UIAlertController = UIAlertController(title: "Logout", message: "Successfully Logged Out!", preferredStyle: .Alert)
            
            
            self.presentViewController(logoutNotification, animated: true, completion: nil)
            logoutNotification.dismissViewControllerAnimated(true, completion: nil)
            self.toolbar.hidden = true
            
            self.mixpanel.track("Logged out")
            
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if let ident = identifier {
            if identifier == "segueToPostDisplay" {
                if PFUser.currentUser() != nil{
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.mixpanel.track("Segue", properties: ["from Map View to Post Display": "Add Button"])
                    print("Should show post display View Controller")
                    return true
                    //show post display view controller
                    //                    var postDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("postDisplayViewController") as! PostDisplayViewController
                    //                    self.presentViewController(postDisplayViewController, animated: true, completion: nil)
                    
                    
                } else {
                    
                    mixpanel.track("Launch Login Screen", properties: ["From which screen": "from MapView(Add button)"])
                    
                    loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .DismissButton]
                    
                    loginViewController.logInView?.backgroundColor = UIColor.whiteColor()
                    let logo = UIImage(named: "logoforparse")
                    let logoView = UIImageView(image: logo)
                    loginViewController.logInView?.logo = logoView
                    
                    loginViewController.signUpController?.signUpView?.logo = logoView
                    
                    
                    
                    parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
                        // Initialize the ParseLoginHelper with a callback
                        print("before the error")
                        if let error = error {
                            // 1
                            ErrorHandling.defaultErrorHandler(error)
                        } else  if user != nil {
                            // if login was successful, display the TabBarController
                            // 2
                            self.fromLoginViewController = true
                            
                            self.mixpanel.track("Login in successful", properties: ["From which screen": "from MapView(Add button)"])
                            print("show post  view controller")
                            
                            //
                            self.mixpanel.track("Segue", properties: ["from Login to Post Display": "Add Button"])
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            self.fromLoginViewController = true
                            
                            self.performSegueWithIdentifier("segueToPostDisplay", sender: self)
                            //****
                            
                            
                        }
                        
                    }
                    
                    
                    
                    loginViewController.delegate = parseLoginHelper
                    loginViewController.signUpController?.delegate = parseLoginHelper
                    
                    
                    
                    
                    self.presentViewController(loginViewController, animated: true, completion: nil)
                    
                    return false
                    
                    
                }
            }
//        }
        
        return false
    }
    
    
    
    @IBOutlet var mapView: MKMapView!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        //            mixpanel.track("Search", parameters: ["With": "Search Bar On Map"])
        
        //        cancel.hidden = false
    }
    
    
    //    var flagged: [AnyObject]?
    //    var flaggedPosts: [Post]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if PFUser.currentUser() != nil{
            toolbar.hidden = false
        } else{
            toolbar.hidden = true
        }
        
        //        cancel.hidden = true
        
        
        print("in MapViewController")
        
        
        
        fromLoginViewController = false
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if annotationCurrent != nil{
            self.mapView.addAnnotation(annotationCurrent!)
            
            let latt = annotationCurrent?.coordinate.latitude
            let longg = annotationCurrent?.coordinate.longitude
            let coordd = CLLocationCoordinate2D(latitude: latt!, longitude: longg!)
            let dumbcoor = CLLocationCoordinate2D(latitude: (latt!) - 1, longitude: (longg!) - 1)
            self.mapView.setCenterCoordinate(dumbcoor, animated: true)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            let region = MKCoordinateRegion(center: coordd, span: span)
            
            regionCenter = region.center
            
            mapView.setRegion(region, animated: true)
            
            
        } else if ann != nil {
            do{
                try ann?.post.delete()
            }catch{
                
            }
            
            self.mapView.removeAnnotation(ann!)
            
        } else if updatedPost != nil {
            let latt = updatedPost?.post.location?.latitude
            let longg = updatedPost?.post.location?.longitude
            let coordd = CLLocationCoordinate2D(latitude: latt!, longitude: longg!)
            let dumbcoor = CLLocationCoordinate2D(latitude: (latt!) - 1, longitude: (longg!) - 1)
            self.mapView.setCenterCoordinate(dumbcoor, animated: true)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            let region = MKCoordinateRegion(center: coordd, span: span)
            
            regionCenter = region.center
            
            mapView.setRegion(region, animated: true)
            
        }
        
        
        
    }
    
    
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBAction func showSearchBar(sender: AnyObject) {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error")
    }
    
    override func viewWillAppear(animated: Bool) {
        toolBar()
    }
    func toolBar() {
        if toolbar != nil{
            if PFUser.currentUser() != nil{
                toolbar.hidden = false
            } else{
                toolbar.hidden = true
            }
        }
    }
    
    //var point = PinAnnotation(title: "newPoint", coordinate: currentLocation!)
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var currentLocation: CLLocationCoordinate2D?
    var regionCenter: CLLocationCoordinate2D?
    var locforPost: CLLocationCoordinate2D?
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if annotationCurrent == nil && updatedPost == nil {
            
            
            let userLocation : CLLocation = locations[0]
            
            self.lat = userLocation.coordinate.latitude
            self.long = userLocation.coordinate.longitude
            
            locforPost = CLLocationCoordinate2DMake(self.lat!, self.long!)
            //self.mapView.addAnnotation(point)
            
            let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            currentLocation = location
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            let region = MKCoordinateRegion(center: location, span: span)
            
            regionCenter = region.center
            
            mapView.setRegion(region, animated: true)
            
            
        }
        locationManager.stopUpdatingLocation()
        
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                if let annotation = view.annotation as? PinAnnotation {
        //            self.mixpanel.track("Segue", properties: ["from Map View to Post": "Annotation callout"])
                    performSegueWithIdentifier("toPostView", sender: annotation)
                }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let loc = PFGeoPoint(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        
        
        let postsQuery = PFQuery(className: "Post")
        
        postsQuery.whereKey("location", nearGeoPoint: loc, withinMiles: 5.0)
        //finds all posts near current locations
        
//        var posts: [PFObject]?
        
        do{
            let posts: [PFObject] = try postsQuery.findObjects()
            
            //        if let pts = posts {
            for post in posts {
                
                //            print(pts.count)
//                print("posts from parse")r
                
                let postcurrent = post as! Post
                
                //            let flagQuery = PFQuery(className: "FlaggedContent")
                //            flagQuery.whereKey("toPost", equalTo: postcurrent)
                //
                //
                //            var flags = flagQuery.findObjects()
                //
                //            if flags.count > 3 {
                //                postcurrent.delete()
                //            } else{
                //
                
                
//                if PFUser.currentUser() != nil{
//                    
//                    //                    let flagQueryForSpecificUser = PFQuery(className: "FlaggedContent")
//                    //
//                    //
//                    //                    flagQueryForSpecificUser.whereKey("fromUser", equalTo: PFUser.currentUser()!)
//                    //                    flagQueryForSpecificUser.whereKey("toPost", equalTo: postcurrent)
//                    //
//                    //                    var flagForSpecificUser = flagQueryForSpecificUser.findObjects()
//                    //
//                    //                    if flagForSpecificUser.count > 0 {
//                    //
//                    //                    } else {
//                    if postcurrent.imageFile != nil && postcurrent.RecipeTitle != nil && postcurrent.location != nil && postcurrent.caption != nil && postcurrent.Instructions != nil && postcurrent.user != nil && postcurrent.date != nil && postcurrent.prep != nil && postcurrent.cook != nil && postcurrent.servings != nil {
//                        print(" make stuff")
//                        let lati = postcurrent.location!.latitude
//                        let longi = postcurrent.location!.longitude
//                        let coor = CLLocationCoordinate2D(latitude: lati, longitude: longi)
//                        
//                        var annotationParseQuery = PinAnnotation?()
//                        
//                        
//                        annotationParseQuery = PinAnnotation(title: postcurrent.RecipeTitle!, coordinate: coor, Description: postcurrent.caption!, instructions: postcurrent.Instructions!, ingredients: postcurrent.Ingredients!, image: postcurrent.imageFile!, user: postcurrent.user!, date: postcurrent.date!, prep: postcurrent.prep!, cook: postcurrent.cook!, servings: postcurrent.servings!, post: postcurrent)
//                        
//                        
//                        //self.mapAnnoations.append(annotationcurrent!)
//                        //println("append")
//                        //for anno in mapAnnoations {
//                        self.mapView.addAnnotation(annotationParseQuery!)
//                        print("addanno")
//                        
//                    }
//                    
//                    //                    }
//                    
//                } else {
                
                    if postcurrent.imageFile != nil && postcurrent.RecipeTitle != nil && postcurrent.location != nil && postcurrent.caption != nil && postcurrent.Instructions != nil && postcurrent.user != nil && postcurrent.date != nil && postcurrent.prep != nil && postcurrent.cook != nil && postcurrent.servings != nil {
                        print(" make stuff")
                        let lati = postcurrent.location!.latitude
                        let longi = postcurrent.location!.longitude
                        let coor = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                        
                        var annotationParseQuery = PinAnnotation?()
                        
                        
                        annotationParseQuery = PinAnnotation(title: postcurrent.RecipeTitle!, coordinate: coor, Description: postcurrent.caption!, instructions: postcurrent.Instructions!, ingredients: postcurrent.Ingredients!, image: postcurrent.imageFile!, user: postcurrent.user!, date: postcurrent.date!, prep: postcurrent.prep!, cook: postcurrent.cook!, servings: postcurrent.servings!, post: postcurrent)
                        
                        
                        //self.mapAnnoations.append(annotationcurrent!)
                        //println("append")
                        //for anno in mapAnnoations {
                        self.mapView.addAnnotation(annotationParseQuery!)
//                        print("addanno")
                        
                    }
                    //                }
                    //                
                    //            }
                    //            }
//                }
                
            }

            
        } catch{
            
        }
        
        //        println(posts![0])
        //
        
        
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation{
            return nil
        } else if !(annotation is PinAnnotation) {
            return nil
        }
        
        var anView: MKAnnotationView?
        
//        if fromTxtField == false{
        
            let identifier = "postsFromParseAnnotations"
            
            anView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                anView!.canShowCallout = true
            }
                
            else {
                
                anView!.annotation = annotation
                
            }
            
            
            
            
            let pinanno = annotation as! PinAnnotation
//            if (pinanno.image.getData() != nil){
                do{
                    let data = try pinanno.image.getData()
                    let size = CGSize(width: 30.0, height: 30.0)
                    
                    let imagee = UIImage(data: data)
                    let scaledImage = imageResize(imagee!, sizeChange: size)
                    anView!.image = scaledImage
                    anView?.layer.borderColor = UIColor.whiteColor().CGColor
                    anView?.layer.borderWidth = 1
                } catch{
                    
                }
        
                
                
                anView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                
//            }
        
            // }
            
//        }
        
        return anView
    }
    
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if let annotation = view.annotation as? PinAnnotation {
////            self.mixpanel.track("Segue", properties: ["from Map View to Post": "Annotation callout"])
//            performSegueWithIdentifier("toPostView", sender: annotation)
//        }
//    }
//        
    
    var coordinateAfterPosted: CLLocationCoordinate2D?
        
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
    var fromTxtField: Bool = false
    //MARK: Map Utilities
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToPostDisplay") {
            let svc = segue.destinationViewController as! PostDisplayViewController;
            
            annotationCurrent = nil
            updatedPost = nil
            if (lat == nil && long == nil){
                lat = 37.40549
                long = -121.977655
            }
            
//            svc.toLoc = PFGeoPoint(latitude: lat!, longitude: long!)
            svc.toLoc = PFGeoPoint(latitude: lat!, longitude: long!)
        }
        
        if (segue.identifier == "toPostView"){
            let annotation = sender as! PinAnnotation
            
            let svc = segue.destinationViewController as! PostViewController;
            svc.anno = annotation
            svc.post = annotation.post
            svc.login = loginViewController
        }
    }
    
    
    
}

