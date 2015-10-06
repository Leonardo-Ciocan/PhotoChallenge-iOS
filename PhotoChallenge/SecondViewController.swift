//
//  SecondViewController.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 01/09/2015.
//  Copyright (c) 2015 LC. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SecondViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    static var following = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func reload(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SecondViewController.following.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : FriendCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FriendCell
        cell.setData(SecondViewController.following[indexPath.item]);
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

}

