//
//  CategoryCell.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 03/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func drawRect(rect: CGRect) {
        //self.layer.cornerRadius = 5.0
        self.layer.backgroundColor = UIColor.grayColor().CGColor
        //self.layer.borderWidth = 1
        
        
    }
    
    func setCategory(name : String){
        title.text = name
    }

}
