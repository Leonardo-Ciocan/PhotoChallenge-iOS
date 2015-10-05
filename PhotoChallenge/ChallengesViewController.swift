//
//  ChallengesViewController.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 03/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ChallengesViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var challenges = [PFObject]()
    var selected : PFObject?
    var selectedCategory : PFObject?
    var submissions = [PFObject]()
    var submissionMap = [PFObject:PFObject]()
    var difficultyMap = [Int:[PFObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = nil

        
        
        let query = PFQuery(className:"Challenge")
        query.whereKey("category", equalTo: selectedCategory!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.challenges = objects!
                for ch in self.challenges{
                    let diff : Int = ch["difficulty"] as! Int
                    if self.difficultyMap[diff] != nil{
                        //let name = ch["name"]
                        //print("Appending \(name) , currently at \(self.difficultyMap[diff]!.count)")
                        //print(self.difficultyMap[diff]!.map({ (v:PFObject) -> String in return (v["name"] as! String)}))
                        self.difficultyMap[diff]!.append(ch)
                    }
                    else{
                        //let name = ch["name"]
                        //print("Adding \(name)")
                        self.difficultyMap[diff] = [ch]
                    }
                    
                }
                self.collectionView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        do {
            let query = PFQuery(className:"Submission")
            query.whereKey("user", equalTo: PFUser.currentUser()!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    self.submissions = objects!
                    self.collectionView.reloadData()
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
        
        print(PFUser.currentUser()?.username)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
      // (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        
        
        //collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.registerNib(UINib(nibName: "ChallengeCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView?.registerNib(UINib(nibName: "DifficultyHeader", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderCell")

        collectionView!.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ChallengeCell
        //cell.setCategory(categories[indexPath.item]["Name"] as! String)
        let challenge : PFObject = (self.difficultyMap[indexPath.section]?[indexPath.item])!
        var submission : PFObject?
        if(submissionMap[challenge] == nil){
            let submissionFilter = submissions.filter({$0["challenge"] as! PFObject == challenge})
            if submissionFilter.count > 0{
                submission = submissionFilter[0]
            }
            submissionMap[challenge] = submission
        }
        else{
            submission = submissionMap[challenge]
        }
        
        
        cell.setChallenge(challenge , submission:submission)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.width/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selected = self.difficultyMap[indexPath.section]![indexPath.item]
        
        
        self.performSegueWithIdentifier("toDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as! DetailViewController
        //destinationVC.navigationItem.title = self.challenges[self.selected]["name"] as! String
        destinationVC.selectedChallenge = self.selected
        destinationVC.selectedSubmission = self.submissionMap[self.selected!]
    }
    
    
    override func viewDidAppear(animated: Bool) {
            self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderCell", forIndexPath: indexPath) as? DifficultyHeader
        switch(indexPath.section){
        case 0:
            headerCell!.setHeaderTitle("EASY")
        case 1:
            headerCell!.setHeaderTitle("MEDIUM")
        case 2:
            headerCell!.setHeaderTitle("HARD")
        default:
            headerCell!.setHeaderTitle("")
        }
        headerCell?.setNeedsDisplay()
        headerCell?.setNeedsLayout()
        headerCell?.layoutIfNeeded()
        return headerCell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: collectionView.bounds.width, height: 65)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        print(self.difficultyMap[section]?.count)
        return self.difficultyMap[section] != nil ? (self.difficultyMap[section]?.count)! : 0;
    }
    
    
}


