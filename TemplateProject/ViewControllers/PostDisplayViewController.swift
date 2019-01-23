//
//  PostDisplayViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import MapKit
import Bond
import FBSDKCoreKit
import Mixpanel

class PostDisplayViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate{
    let mixpanel = Mixpanel.sharedInstance()

    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var ingTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cookTime: UITextField!
    private var responseData:NSMutableData?
    
    @IBOutlet weak var numOfServings: UITextField!
    @IBOutlet weak var prepTime: UITextField!
    private var connection:NSURLConnection?
    
    private let googleMapsKey = "AIzaSyD8-OfZ21X2QLS1xLzu1CLCfPVmGtch7lo"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView?
    //    @IBOutlet weak var instructionTableView: UITableView!
    @IBOutlet weak var descriptionText: UITextView!
    //    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var placeholderLabel: UILabel!
    var placeholderInstructionsLabel: UILabel!
    var placeholderIngredientsLabel: UILabel!
    
    var placeholderInstructionsLabelExample: UILabel!
    var placeholderIngredientsLabelExample: UILabel!
    
    var locationLabelFromPostDisplay: String?

    
    
    let post = Post()
    
    var toLoc: PFGeoPoint?
    var image: UIImage?
    var annotation: PinAnnotation?
    @IBOutlet weak var cameraButton: UIButton!
    
    var ing: [String]?
    var ins: [String]?
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == prepTime{
            let newLength = (textField.text!).characters.count + string.characters.count - range.length
            return newLength <= 13 //Bool
        } else if textField == cookTime {
            let newLength = (textField.text!).characters.count + string.characters.count - range.length
            return newLength <= 13 //Bo
        } else if textField == numOfServings {
            let newLength = (textField.text!).characters.count + string.characters.count - range.length
            return newLength <= 13 //Bo
        } else {
            let newLength = (textField.text!).characters.count + string.characters.count - range.length
            return newLength <= 100 //Bo
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel?", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
            self.dismissViewControllerAnimated(false, completion: nil)
            self.presentViewController(mapViewController, animated: true, completion: nil)
            mapViewController.viewDidAppear(true)
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Continue", style: .Default) { action -> Void in
            //Do some other stuff
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
        
        //Do some stuff
        
        //Present the AlertController
        
    }
    
    func clearEverything(){
        
        navbar.topItem?.title = "Create a Recipe"
        
        placeholderLabel.hidden = false

        titleTextField.text = ""
        descriptionText.text = ""
        imageView?.image = nil
        prepTime.text = ""
        cookTime.text = ""
        numOfServings.text = ""
        ingTextView.text = ""
        instructionsTextView.text = ""
        cameraButton.hidden = false
        placeholderIngredientsLabel.hidden = false
        placeholderIngredientsLabelExample.hidden = false
        placeholderInstructionsLabel.hidden = false
        placeholderInstructionsLabelExample.hidden = false
        let point = CGPoint(x: 0, y: self.scrollView.contentInset.top)
        self.scrollView.setContentOffset(point, animated: true)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if let ident = identifier {
            if identifier == "fromPostDiplayToMap" {
                if titleTextField.text == "" {
                    emptyLabel.text = "Please enter a title."
                    emptyLabel.hidden = false
                    
                } else if imageView?.image == nil {
                    emptyLabel.text = "Please add an image."
                    emptyLabel.hidden = false
                    
                } else if prepTime.text == ""{
                    emptyLabel.text = "Please enter a prep time."
                    emptyLabel.hidden = false
                    
                } else if cookTime.text == "" {
                    emptyLabel.text = "Please enter a cook time."
                    emptyLabel.hidden = false
                    
                } else if numOfServings.text == "" {
                    emptyLabel.text = "Please enter the number of servings."
                    emptyLabel.hidden = false
                    
                } else if ingTextView.text == nil {
                    emptyLabel.text = "Please enter at least one ingredient."
                    emptyLabel.hidden = false
                    
                } else if instructionsTextView.text == nil {
                    emptyLabel.text = "Please enter at least one instruction."
                    emptyLabel.hidden = false
                    
                } else {
                    return true
                }
            } else if identifier == "PresentEditLocationScene" {
                    return true
                
            }
//        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        //println("hi")
        photoTakingHelper =
            PhotoTakingHelper(viewController: self) { (image: UIImage?) in
                // 1
                
                self.post.image.value = image!
                
                self.imageView?.image = image!
                
                let imageData = UIImageJPEGRepresentation(image!, 0.8)
                let imageFile = PFFile(data: (imageData)!)
                //imageFile.save()
                
                //let post = PFObject(className: "Post")
                if self.annotation == nil {
                    self.post["imageFile"] = imageFile
                    do{
                        try self.post.save()
                    } catch{
                        
                    }
                    
                } else {
                    let imageData = UIImageJPEGRepresentation((self.imageView?.image)!, 0.8)
                    let imageFile = PFFile(data: imageData!)
                    
                    self.annotation?.post.imageFile = imageFile
                    do{
                        try self.annotation?.post.imageFile?.save()
                    } catch{
                        
                    }
                    
                }
                
                self.cameraButton.hidden = true
        }
        
    }
    
    var ingredientsArray: [String] = []
    var instructionsArray: [String] = []
    func textViewDidChange(textView: UITextView) {
        if textView == descriptionText{
            placeholderLabel.hidden = textView.text.characters.count != 0
            
        } else if textView == ingTextView{
            placeholderIngredientsLabel.hidden = textView.text.characters.count != 0
            placeholderIngredientsLabelExample.hidden = textView.text.characters.count != 0
            
        } else if textView == instructionsTextView {
            placeholderInstructionsLabel.hidden = textView.text.characters.count != 0
            placeholderInstructionsLabelExample.hidden = textView.text.characters.count != 0
            
        }
    }
    
    
    func appendIngredientsAndInstructions(){
        
        let ingredi = ingTextView.text.characters.split {$0 == "\n"}.map { String($0) }
        self.ingredientsArray = ingredi
        
        
        let instruc = instructionsTextView.text.characters.split {$0 == "\n"}.map { String($0) }
        
        self.instructionsArray = instruc
        
    }
    
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        ingTextView.endEditing(true)
        descriptionText.endEditing(true)
        instructionsTextView.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleTextField.delegate = self
        prepTime.delegate = self
        cookTime.delegate = self
        numOfServings.delegate = self
        
        emptyLabel.hidden = true
        
        imageView!.layer.borderWidth = 0.5
        imageView!.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).CGColor
        imageView!.layer.cornerRadius = 5
        
        
        ingTextView.layer.borderWidth = 0.5
        ingTextView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).CGColor
        ingTextView.layer.cornerRadius = 5
        
        
        instructionsTextView.layer.borderWidth = 0.5
        instructionsTextView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).CGColor
        instructionsTextView.layer.cornerRadius = 5
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
        
        scrollView.contentSize.width = screenWidth
        
        descriptionText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write a caption..."
        placeholderLabel.sizeToFit()
        descriptionText.addSubview(placeholderLabel)
        
        placeholderLabel.frame.origin = CGPointMake(5, descriptionText.font!.pointSize / 2)
        placeholderLabel.font = UIFont(name: placeholderLabel.font.fontName, size: 12)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.2)
        placeholderLabel.hidden = descriptionText.text.characters.count != 0
        
        ingTextView.delegate = self
        placeholderIngredientsLabel = UILabel()
        placeholderIngredientsLabel.font = UIFont(name: placeholderLabel.font.fontName, size: 12)
        placeholderIngredientsLabel.text = "Put each new ingredient on a separate line."
        placeholderIngredientsLabel.sizeToFit()
        ingTextView.addSubview(placeholderIngredientsLabel)
        
        placeholderIngredientsLabel.frame.origin = CGPointMake(5, ingTextView.font!.pointSize / 2)
        placeholderIngredientsLabel.textColor = UIColor(white: 0, alpha: 0.2)
        placeholderIngredientsLabel.hidden = ingTextView.text.characters.count != 0
        
        
        instructionsTextView.delegate = self
        placeholderInstructionsLabel = UILabel()
        placeholderInstructionsLabel.font = UIFont(name: placeholderLabel.font.fontName, size: 12)
        placeholderInstructionsLabel.text = "Put each new instruction on a separate line."
        placeholderInstructionsLabel.sizeToFit()
        instructionsTextView.addSubview(placeholderInstructionsLabel)
        
        placeholderInstructionsLabel.frame.origin = CGPointMake(5, descriptionText.font!.pointSize / 2)
        placeholderInstructionsLabel.textColor = UIColor(white: 0, alpha: 0.2)
        placeholderInstructionsLabel.hidden = instructionsTextView.text.characters.count != 0
        
        
        placeholderInstructionsLabelExample = UILabel()
        placeholderInstructionsLabelExample.font = UIFont(name: placeholderLabel.font.fontName, size: 12)
        placeholderInstructionsLabelExample.text = "Ex. Preheat oven to 350 degrees F."
        placeholderInstructionsLabelExample.sizeToFit()
        instructionsTextView.addSubview(placeholderInstructionsLabelExample)
        
        placeholderInstructionsLabelExample.frame.origin = CGPoint(x: 5, y: 22)
        placeholderInstructionsLabelExample.textColor = UIColor(white: 0, alpha: 0.2)
        placeholderInstructionsLabelExample.hidden = instructionsTextView.text.characters.count != 0
        
        
        placeholderIngredientsLabelExample = UILabel()
        placeholderIngredientsLabelExample.font = UIFont(name: placeholderLabel.font.fontName, size: 12)
        placeholderIngredientsLabelExample.text = "Ex. 3 eggs"
        placeholderIngredientsLabelExample.sizeToFit()
        ingTextView.addSubview(placeholderIngredientsLabelExample)
        
        placeholderIngredientsLabelExample.frame.origin = CGPoint(x: 5, y: 22)
        placeholderIngredientsLabelExample.textColor = UIColor(white: 0, alpha: 0.2)
        placeholderIngredientsLabelExample.hidden = ingTextView.text.characters.count != 0
        
        appendIngredientsAndInstructions()
        
        if annotation?.post != nil{
            do{
            let data = try annotation?.image.getData()
            image = UIImage(data: data!)
            } catch{
                
            }
            imageView?.image = image
            
            
        }
        
        
        if (annotation?.ingredients != nil && annotation?.instructions != nil && annotation?.title != nil && annotation?.Description != nil && annotation?.image != nil && annotation?.servings != nil && annotation?.prep != nil && annotation?.cook != nil) {
            
            navbar.topItem?.title = "Edit Post"
            
            titleTextField.text = annotation?.title
            descriptionText.text = annotation?.Description
            cookTime.text = annotation?.cook
            prepTime.text = annotation?.prep
            numOfServings.text = annotation?.servings
            
            
            if locationLabelFromPostDisplay != nil{
             
                _ = locationLabelFromPostDisplay
                
                annotation?.post.location = pfgeopoint
                
                
            }
            
            
            
            let ingredientsArrayFromMap = annotation?.ingredients
            let stringedi = (ingredientsArrayFromMap!).joinWithSeparator("\n")
            ingTextView.text = stringedi
            
            
            let instructionsArrayFromMap = annotation?.instructions
            let strinstuc = (instructionsArrayFromMap!).joinWithSeparator("\n")
            instructionsTextView.text = strinstuc
            
            //            autocompleteTextfield.enabled = false
            
            placeholderLabel.hidden = descriptionText.text.characters.count != 0
            placeholderIngredientsLabel.hidden = ingTextView.text.characters.count != 0
            
            placeholderInstructionsLabel.hidden = instructionsTextView.text.characters.count != 0
            
            placeholderIngredientsLabelExample.hidden = ingTextView.text.characters.count != 0
            placeholderInstructionsLabelExample.hidden = ingTextView.text.characters.count != 0
            
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    var coordinateh: CLLocationCoordinate2D?
    
    var pfgeopoint: PFGeoPoint?
    
    //MARK: NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentAnnotation: PinAnnotation?
    
    
    
    func updatePost() {
        
        appendIngredientsAndInstructions()
        
        annotation?.post.prep = prepTime.text
        annotation?.post.cook = cookTime.text
        annotation?.post.servings = numOfServings.text
        annotation?.post.RecipeTitle = titleTextField.text
        annotation?.post.caption = descriptionText.text
        annotation?.post.Ingredients = ingredientsArray
        annotation?.post.Instructions = instructionsArray
        
        
        do{
            try annotation?.post.save()
        } catch{
            
        }
        annotation?.post.saveInBackgroundWithBlock(nil)
        
        
    }
    
    func createPost(){
        
        appendIngredientsAndInstructions()
        
        if pfgeopoint == nil {
            pfgeopoint = toLoc
        }
        
        post.prep = prepTime.text
        post.cook = cookTime.text
        post.servings = numOfServings.text
        post.caption = descriptionText.text
        post.RecipeTitle = titleTextField.text
        post.location = pfgeopoint
        post.Ingredients = self.ingredientsArray
        post.Instructions = self.instructionsArray
        post.date = NSDate()
        
        if titleTextField.text == "" {
            emptyLabel.text = "Please enter a title."
            emptyLabel.hidden = false
            
        } else if imageView?.image == nil {
            emptyLabel.text = "Please add an image."
            emptyLabel.hidden = false
            
        } else if prepTime.text == ""{
            emptyLabel.text = "Please enter a prep time."
            emptyLabel.hidden = false
            
        } else if cookTime.text == "" {
            emptyLabel.text = "Please enter a cook time."
            emptyLabel.hidden = false
            
        } else if numOfServings.text == "" {
            emptyLabel.text = "Please enter the number of servings."
            emptyLabel.hidden = false
            
        } else if ingTextView.text == nil {
            emptyLabel.text = "Please enter at least one ingredient."
            emptyLabel.hidden = false
            
        } else if instructionsTextView.text == nil {
            emptyLabel.text = "Please enter at least one instruction."
            emptyLabel.hidden = false
            
        } else {
            do{
                try post.save()
            } catch{
                
            }
            post.uploadPost()
        }

        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        _ = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        
        
        _ = post.Ingredients!
        
      
        if coordinateh == nil{
            let latitu = toLoc?.latitude
            let longit = toLoc?.longitude
            
            coordinateh = CLLocationCoordinate2DMake(latitu!, longit!)
        }
        
        let annotationToAdd = PinAnnotation(title: post.RecipeTitle!, coordinate: coordinateh!, Description: post.caption!, instructions: post.Instructions!, ingredients: post.Ingredients!, image: post.imageFile!, user: post.user!, date: post.date!, prep: post.prep!, cook: post.cook!, servings: post.servings!, post: post)
        
        currentAnnotation = annotationToAdd

        
        
    }
    
}
