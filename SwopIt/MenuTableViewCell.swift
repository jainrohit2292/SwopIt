//
//  MenuTableViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/7/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemTitleLbl: UILabel!
    @IBOutlet weak var menuItemImgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(image: UIImage?, title: String){
        self.menuItemImgV.image = image
        self.menuItemTitleLbl.text = title
    }
    
}
