//
//  ItemDetailImageCollectionViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/17/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class ItemDetailImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(imageUrl: String){
        self.itemImageV.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
    }
}
