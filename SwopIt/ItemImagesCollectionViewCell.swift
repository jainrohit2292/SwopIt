//
//  ItemImagesCollectionViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/16/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class ItemImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(image: UIImage){
        self.itemImageV.image = image
    }

}
