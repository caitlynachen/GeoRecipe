//
//  PostViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse
import ParseUI
import FBSDKCoreKit
import Mixpanel


class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let mixpanel = Mixpanel.sharedInstance()
    
//    var flagBond: Bond<[PFUser]?>!
    
    
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var cook: UILabel!
    @IBOutlet weak var prep: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var geoButton: UIButton!
    
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var anno: PinAnnotation?
    
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var imageViewDisplay: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
//    var likeBond: Bond<[PFUser]?>!
    
    let loginViewController = PFLogInViewController()
    
    var parseLoginHelper: ParseLoginHelper!
    
    
    @IBOutlet weak var likeLabel: UILabel!
    
    var login: PFLogInViewController?
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("backButtonToMap", sender: nil)
    }
    
    
    
    @IBAction func geoButtonTApped(sender: AnyObject) {
        self.performSegueWithIdentifier("fromGeoButtonToMap", sender: nil)
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
//        let pushQuery: PFQuery = PFInstallation.query()!
//        pushQuery.whereKey("deviceType", equalTo: "ios")
        
        if PFUser.currentUser() != nil{
            likeButton.selected = true
            
            likeLabel.text = PFUser.currentUser()?.username
        }
//        
//        let push = PFPush()
//        push.setQuery(pushQuery)
//        push.setMessage("Hello, World!")
//        
//        push.sendPushInBackgroundWithBlock(nil)
//        
//        mixpanel.track("Like process", properties: ["action": "like tapped"])
//        if PFUser.currentUser() != nil{
//            mixpanel.track("Like process", properties: ["action": "already logged in"])
//            
////            anno?.post.toggleLikePost(PFUser.currentUser()!)
//            
//            // Create our Installation query
//            
//        } else{
//            //login parse viewcontroller
//            mixpanel.track("Like process", properties: ["action": "launch login screen"])
//            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .DismissButton]
//            
//            loginViewController.logInView?.backgroundColor = UIColor.whiteColor()
//            let logo = UIImage(named: "logoforparse")
//            let logoView = UIImageView(image: logo)
//            loginViewController.logInView?.logo = logoView
//            
//            
//            loginViewController.signUpController?.signUpView?.logo = logoView
//
//            
//            parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
//                // Initialize the ParseLogiseguenHelper with a callback
//                print("before the error")
//                if let error = error {
//                    // 1
//                    ErrorHandling.defaultErrorHandler(error)
//                } else  if user != nil {
//                    // if login was successful, display the TabBarController
//                    // 2
//                    self.mixpanel.track("Like process", properties: ["action": "login completed and liked"])
//                    print("show post  view controller")
//                    
//                    self.loginViewController.dismissViewControllerAnimated(true, completion: nil)
//                    //****
////                    self.anno?.post.toggleLikePost(PFUser.currentUser()!)
//                    
//                    
//                }
//            }
//            
//            loginViewController.delegate = parseLoginHelper
//            loginViewController.signUpController?.delegate = parseLoginHelper
//            
//            
//            
//            self.presentViewController(loginViewController, animated: true, completion: nil)
//            
//            
//        }
    }
    
    var post: Post? {
        didSet {
            // free memory of image stored with post that is no longer displayed
            // 1
//            if let oldValue = oldValue where oldValue != post {
//                // 2
////                likeBond.unbindAll()
//                imageViewDisplay.designatedBond.unbindAll()
//                // 3
//                if (oldValue.image.bonds.count == 0) {
//                    oldValue.image.value = nil
//                }
//            }
//            
////            if let post = post  {
////                if likeButton != nil {
////                    // bind the image of the post to the 'postImage' view
////                    // bind the likeBond that we defined earlier, to update like label and button when likes change
////                    post.likes ->> likeBond
////                }
////            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 1
        
//        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
//            // 2
//            if let likeList = likeList {
//                // 3
//                
//                self.likeLabel.text = self.stringFromUserList(likeList)
//                
//                
//                // 4
//                if PFUser.currentUser() != nil{
//                    self.likeButton.selected = contains(likeList, PFUser.currentUser()!)
//                    
//
//                }
//                // 5
//            } else {
//                //                self.likeLabel = UILabel()
//                //                self.likeButton = UIButton()
//                // 6
//                // if there is no list of users that like this post, reset everything
//                self.likeLabel.text = ""
//                self.likeButton.selected = false
//            }
//        }
    }
    
    func stringFromUserList(userList: [PFUser]) -> String {
        // 1
        let usernameList = userList.map { user in user.username! }
        // 2
        let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
        
        if usernameList.count < 4 {
            
            return commaSeparatedUserList
        } else {
            let string = "\(usernameList.count)"
            return string
        }
    }
    
//    func flagBondz (){
//        anno?.post.fetchFlags()
//        
//        var flags = anno?.post.flags
//        
//        
//       flagBond = Bond<[PFUser]?>() { [unowned self] flagList in
//            
//            if let flagList = flagList {
//                if flagList.count > 4 {
//                    self.performSegueWithIdentifier("fromPostMap", sender: nil)
//                } else {
//                    self.performSegueWithIdentifier("fromPostMapForFlagBond", sender: nil)
//                }
//                
//            }
//        }
//        
//        flags! ->> flagBond
//
//        
//        
//        
//    }
    
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        if(PFUser.currentUser()?.username == usernameLabel.text){
            let actionSheetController: UIAlertController = UIAlertController()
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelAction)
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let deleteAlert: UIAlertController = UIAlertController(title: "Confirm Deletion", message: "Delete Photo?", preferredStyle: .Alert)
                
                let dontDeleteAction: UIAlertAction = UIAlertAction(title: "Don't Delete", style: .Cancel) { action -> Void in
                }
                deleteAlert.addAction(dontDeleteAction)
                let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                    
                    //                    self.anno?.post.delete()
                    self.mixpanel.track("Segue", properties: ["from Post to Map View": "Delete"])
                    
                    self.performSegueWithIdentifier("fromPostMap", sender: nil)
                    
                }
                deleteAlert.addAction(deleteAction)
                
                
                //Present the AlertController
                self.presentViewController(deleteAlert, animated: true, completion: nil)
            }
            actionSheetController.addAction(takePictureAction)
//            let choosePictureAction: UIAlertAction = UIAlertAction(title: "Edit", style: .Default) { action -> Void in
//                self.performSegueWithIdentifier("editPost", sender: nil)
//                self.mixpanel.track("Segue", properties: ["from Post to Map View": "Edit"])
//            }
//            actionSheetController.addAction(choosePictureAction)
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = sender as? UIView;
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        } else{
            let actionSheetController: UIAlertController = UIAlertController()
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Report Inappropriate", style: .Default) { action -> Void in
                let deleteAlert: UIAlertController = UIAlertController(title: "Flag", message: "Are you sure you want to flag this recipe?", preferredStyle: .Alert)
                
                let dontDeleteAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                }
                deleteAlert.addAction(dontDeleteAction)
                let deleteAction: UIAlertAction = UIAlertAction(title: "Flag", style: .Default) { action -> Void in
                    
                    if PFUser.currentUser() != nil{
//                        self.anno?.post.flagPost(PFUser.currentUser()!)
                        
                        self.mixpanel.track("Segue", properties: ["from Post to Map View": "Flag"])
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
                        self.dismissViewControllerAnimated(false, completion: nil)
                        self.presentViewController(mapViewController, animated: true, completion: nil)

                    } else{
                        //login parse viewcontroller
                        self.loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .DismissButton]
                        
                        self.loginViewController.logInView?.backgroundColor = UIColor.whiteColor()
                        let logo = UIImage(named: "logoforparse")
                        let logoView = UIImageView(image: logo)
                        self.loginViewController.logInView?.logo = logoView
                        
                        self.loginViewController.signUpController?.signUpView?.logo = logoView

                        
                        self.parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
                            // Initialize the ParseLogiseguenHelper with a callback
                            print("before the error")
                            if let error = error {
                                // 1
                                ErrorHandling.defaultErrorHandler(error)
                            } else  if user != nil {
                                
//                                self.anno?.post.flagPost(PFUser.currentUser()!)
                                
                                self.mixpanel.track("Segue", properties: ["from Post to Map View": "Flag"])
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
                                self.dismissViewControllerAnimated(false, completion: nil)
                                self.presentViewController(mapViewController, animated: true, completion: nil)

                            }
                        }
                        
                        self.loginViewController.delegate = self.parseLoginHelper
                        self.loginViewController.signUpController?.delegate = self.parseLoginHelper
                        
                        
                        
                        self.presentViewController(self.loginViewController, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                deleteAlert.addAction(deleteAction)
                
                
                //Present the AlertController
                self.presentViewController(deleteAlert, animated: true, completion: nil)
            }
            actionSheetController.addAction(takePictureAction)
            //Create and add a second option action
            
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = sender as? UIView;
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToPostView(segue:UIStoryboardSegue) {
        if(segue.identifier == "unwindToPostView"){
            
            
        } else if (segue.identifier == "fromLoginToPostView"){
            
        }
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if let ident = identifier {
            if identifier == "toRecipeView" {
                return true
            } else if identifier == "toCommentView" {
                return true
            }
            
//        }
        
        return false
        
    }
    
    var ing: [String]?
    var ins: [String]?
    
    var image: UIImage?
    
    override func viewDidAppear(animated: Bool) {
        ingredientsTableView.reloadData()
        instructionsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTableView.delegate = self
        
        
        instructionsTableView.delegate = self
        
        
        ing = anno?.ingredients
        ins = anno?.instructions
        
        self.ingredientsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.instructionsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "instruccell")
        
        
        geoButton.setTitle(anno?.title, forState: .Normal)
        //post = anno?.post
        cook.text = anno?.cook
        prep.text = anno?.prep
        servings.text = anno?.servings
        titleLabel.text = anno?.title
        DescriptionLabel.text = anno?.Description
        do{
            _ = try anno?.user.fetchIfNeeded()
        } catch{
            
        }
        usernameLabel.text = anno?.user.username
        
        dateLabel.text = anno?.date.shortTimeAgoSinceDate(NSDate())
        
        do{
            let data = try anno?.image.getData()
            image = UIImage(data: data!)
        } catch{
            
        }
        imageViewDisplay.image = image
//        anno?.post.fetchLikes()
        
//        if let post = post {
//            // bind the image of the post to the 'postImage' view
//            // bind the likeBond that we defined earlier, to update like label and button when likes change
//            post.likes ->> likeBond
//        }
        // Do any additional setup after loading the view.
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            let i = anno?.ingredients.count
            return i!
        } else {
            let i = anno?.instructions.count
            return i!
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myFont = UIFont(name: "Arial", size: 14.0)
        if tableView == ingredientsTableView {
//            let cell: UITableViewCell = ((self.ingredientsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell))!
            let cell: UITableViewCell = self.ingredientsTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            let width = ingredientsTableView.frame.width
            
            cell.textLabel?.frame = CGRect(x: 0, y: 0, width: width, height: CGFloat.max)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.textLabel?.sizeToFit()
            
            cell.textLabel?.font = myFont
            cell.textLabel?.text = anno?.ingredients[indexPath.row]
            
            
            return cell
            
        } else {
            let cell: UITableViewCell = self.instructionsTableView.dequeueReusableCellWithIdentifier("instruccell")! as UITableViewCell
            let width = instructionsTableView.frame.width
            
            cell.textLabel?.frame = CGRect(x: 0, y: 0, width: width, height: CGFloat.max)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.textLabel?.sizeToFit()
            
            
            cell.textLabel?.font = myFont
            cell.textLabel?.text = anno?.instructions[indexPath.row]
            return cell
        }
        
    }
    
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editPost"){
            let dest = segue.destinationViewController as! PostDisplayViewController;
            
            dest.annotation = anno
            
        }
            
            
        else if(segue.identifier == "fromPostMap"){
            
            let dest = segue.destinationViewController as! MapViewController;
            dest.ann = anno
            
            
        } 
//        else if (segue.identifier == "fromGeoButtonToMap"){
//            self.mixpanel.track("Segue", properties: ["from Post to Map View": "Geo Button"])
//            var dest = segue.destinationViewController as! MapViewController;
//            dest.fromGeoButton = true
//            dest.geoButtonTitle = anno?.subtitle
//            let mapViewController = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
//            
//            
//        }
        else if (segue.identifier == "fromPostMapForFlagBond"){
            let dest = segue.destinationViewController as! MapViewController;
            dest.annForFlagPost = anno
        }
    }
    
    
    
    
}
