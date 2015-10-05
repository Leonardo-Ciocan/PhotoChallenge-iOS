//
//  ChallengeCell.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 03/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit
import Parse
import Bolts

class ChallengeCell: UICollectionViewCell {
    
    @IBOutlet weak var title : UILabel?
    @IBOutlet weak var img: UIImageView!
    
    var effect :UIVisualEffectView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override var bounds: CGRect {
        didSet {
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func drawRect(rect: CGRect) {
        //self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1
    }
    
    func setChallenge(item : PFObject , submission :PFObject?){
        title!.text = item["name"] as! String
        if submission != nil{
            if let pic = submission?.objectForKey("photo") as! PFFile? {
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
        }
        else{
            self.img.image = nil;
        }
    }
    
}
