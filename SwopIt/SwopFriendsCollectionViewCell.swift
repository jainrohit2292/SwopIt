//
//  SwopFriendsCollectionViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 6/3/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import SDWebImage
class SwopFriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var aboutLbl: UILabel!
   
    @IBOutlet weak var profileImageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(user: User){
        let url = URL(string: user.profilePictureUrl!)
        self.profileImageV.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_placeholder"))
        self.profileImageV.layer.cornerRadius = self.profileImageV.frame.width/2
        self.profileImageV.clipsToBounds = true
        self.usernameLbl.text = user.username
        self.aboutLbl.text = user.about
    }
    
}
