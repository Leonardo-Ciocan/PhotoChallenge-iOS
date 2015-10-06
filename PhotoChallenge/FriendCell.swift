//
//  FriendCell.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 06/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit
import Parse
import Bolts

class FriendCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    let topBorder = CALayer()

    override func awakeFromNib() {
        super.awakeFromNib()

        topBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        topBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1 , self.bounds.width, 1)
        self.layer.addSublayer(topBorder)
    }
    
    override func drawRect(rect: CGRect) {
        //self.layer.borderColor = UIColor.grayColor().CGColor
        //self.layer.borderWidth = 1
    }

    
    func setData(data:PFObject){
        
        let user : PFUser = data["following"] as! PFUser
        do{
            try user.fetchIfNeeded()
        }
        catch{
            
        }
        topBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1 , self.bounds.width, 1)

        username.text = user.username
    }
}
