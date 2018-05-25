//
//  CategoriesCollectionViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/15/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var catImageV: UIImageView!
    @IBOutlet weak var catLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateCell(image: UIImage?, title: String){
        self.catImageV.image = image
        self.catLbl.text = title
    }
}
