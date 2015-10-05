//
//  DifficultyHeader.swift
//  PhotoChallenge
//
//  Created by Leonardo Ciocan on 04/10/2015.
//  Copyright © 2015 LC. All rights reserved.
//

import UIKit

class DifficultyHeader: UICollectionReusableView {

    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setHeaderTitle(hTitle:String){
        title.text = hTitle
    }
}
