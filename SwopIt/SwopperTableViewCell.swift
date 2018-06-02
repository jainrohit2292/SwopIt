//
//  SwopperTableViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 6/2/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import SDWebImage

class SwopperTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImgV: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(user: User){
        self.usernameLbl.text = user.username
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        let profUrl = URL(string: Constants.GET_PROFILE_PIC_URL + user.profilePictureUrl!)
        self.profileImgV.sd_setImage(with: profUrl, placeholderImage: UIImage(named: "profile_placeholder"))
    }
}
