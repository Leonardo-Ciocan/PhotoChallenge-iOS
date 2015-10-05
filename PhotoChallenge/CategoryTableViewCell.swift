//
//  CategoryTableViewCell.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 03/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = 5.0
    }

}
