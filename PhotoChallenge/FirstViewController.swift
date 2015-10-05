//
//  FirstViewController.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 01/09/2015.
//  Copyright (c) 2015 LC. All rights reserved.
//

import UIKit
import Parse
import Bolts

class FirstViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {

    @IBOutlet weak var collectionView: UICollectionView!
    var categories = [PFObject]()
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barStyle = .BlackTranslucent
        
        let query = PFQuery(className:"Category")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.categories = objects!
                self.collectionView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        //collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
       collectionView!.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CategoryCell
        cell.setCategory(categories[indexPath.item]["Name"] as! String)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: ceil(collectionView.bounds.width/3-5),
                          height:ceil(collectionView.bounds.width/3-5))
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selected = indexPath.item
        
            self.performSegueWithIdentifier("toChallenges", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as! ChallengesViewController
        destinationVC.navigationItem.title = self.categories[self.selected]["Name"] as! String
        destinationVC.selectedCategory = self.categories[self.selected]
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
    }
    
    
}


