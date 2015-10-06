//
//  DetailViewController.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 04/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit
import Parse
import Bolts
import TOCropViewController

class DetailViewController: UIViewController , TOCropViewControllerDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    var selectedSubmission : PFObject?
    var selectedChallenge : PFObject?
    var challengesController : ChallengesViewController?
    var friendSubmissionsArr = [PFObject]()
    
    @IBOutlet weak var friendSubmissions: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedSubmission != nil{
            if let pic = selectedSubmission?.objectForKey("photo") as! PFFile? {
                pic.getDataInBackgroundWithBlock({
                    (data: NSData?, error: NSError?) -> Void in
                    if((error) == nil && data != nil)
                    {
                        if let image = UIImage(data: data!)
                        {
                            self.image.image = image
                        }
                    }
                })
            }
        }
        
        let following = SecondViewController.following.map( {
            (o:PFObject) -> PFUser in
                return o["following"] as! PFUser
        });
        
        let s = following.map( {
            (o:PFUser) -> String in
            do{
             try o.fetchIfNeeded()
            }
            catch{
                
            }
            return o.username!
        });
        
        print(s)
        
        let query = PFQuery(className:"Submission")
        query.whereKey("user", containedIn: following)
        query.whereKey("challenge", equalTo: self.selectedChallenge!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.friendSubmissionsArr = objects!
                self.friendSubmissions.titleLabel?.text = "\(objects!.count) friends submitted"
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
        categoryLabel.text = selectedChallenge!["category"]["Name"] as! String
        titleLabel.text = selectedChallenge!["name"] as! String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let cameraOption = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .Camera
            self.presentViewController(picker, animated: true, completion: nil)
        })
        
        let libOption = UIAlertAction(title: "Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        })
        
        
        optionMenu.addAction(cameraOption)
        optionMenu.addAction(libOption)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismissViewControllerAnimated(true, completion: nil)

        let cropview = TOCropViewController(image: info[UIImagePickerControllerOriginalImage] as! UIImage)
        cropview.delegate = self
        (cropview.view.subviews[0] as! TOCropView).setAspectLockEnabledWithAspectRatio(CGSize(width: 1, height: 1), animated: false)
        self.presentViewController(cropview, animated: true, completion: nil)
        self.image.alpha = 0
        print("picker")
    }
    
    func cropViewController(cropViewController: TOCropViewController!, didCropToImage img: UIImage!, withRect cropRect: CGRect, angle: Int){
        self.image.image = img
        self.image.setNeedsDisplay()
        cropViewController.dismissAnimatedFromParentViewController(self, toFrame: self.image.frame, completion: {() -> Void in
                self.image.alpha = 1
            self.setPhoto(img)
            
        })
    }
    
    func setPhoto(img: UIImage){
        let file = PFFile(data: UIImageJPEGRepresentation(img, 0.9)!)
        if self.selectedSubmission != nil{
            self.selectedSubmission?.setObject(file, forKey: "photo")
            self.selectedSubmission?.saveInBackground()
        }
        else{
            self.selectedSubmission = PFObject(className: "Submission")
            self.selectedSubmission?.setObject(PFUser.currentUser()!, forKey: "user")
            self.selectedSubmission?.setObject(self.selectedChallenge!, forKey: "challenge")
            self.selectedSubmission?.setObject(file, forKey: "photo")
            self.selectedSubmission?.saveInBackground()
            self.challengesController?.submissionMap[self.selectedChallenge!] = self.selectedSubmission
            self.challengesController?.submissions.append(self.selectedChallenge!)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func seeFriendSubs(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! FollowingViewController
        destinationVC.submissions = self.friendSubmissionsArr
    }
    

}
