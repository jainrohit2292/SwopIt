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
        var titleText = title
        self.menuItemTitleLbl.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        if (titleText == "Inbox") {
            if (Utils.getNewMessageCount() != nil ){
                let msgCount = Utils.getNewMessageCount()
                if(msgCount != "0" && msgCount != ""){
                    titleText = "Inbox (" + msgCount! + ")"
                    self.menuItemTitleLbl.font = UIFont.boldSystemFont(ofSize: 12.0)
                }
            }
        }
        self.menuItemTitleLbl.text = titleText
    }
    
}
