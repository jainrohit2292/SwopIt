//
//  ChatListTableViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/30/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import SDWebImage
class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
   
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func updateCell(user: User){
        let picUrl = URL(string: user.profilePictureUrl!)
        if(picUrl != nil){
            self.profileImgV.sd_setImage(with: picUrl!, placeholderImage: UIImage(named: "profile_placeholder"))
        }
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        self.usernameLbl.text = user.username
        self.msgLbl.text = user.about
    }
    
}
