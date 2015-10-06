//
//  FollowingPictureCell.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 06/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit
import Parse
import Bolts

class FollowingPictureCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var userLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(item:PFObject){
            if let pic = item.objectForKey("photo") as! PFFile? {
                pic.getDataInBackgroundWithBlock({
                    (data: NSData?, error: NSError?) -> Void in
                    if((error) == nil && data != nil)
                    {
                        if let image = UIImage(data: data!)
                        {
                            self.img.image = image
                        }
                    }
                })
            }
        
        var user : PFUser = item.objectForKey("user") as! PFUser
        do{
            try user.fetchIfNeeded()
        }
        catch{
            
        }
        
        userLabel.text = user["name"] as! String
        
        
    }
}
