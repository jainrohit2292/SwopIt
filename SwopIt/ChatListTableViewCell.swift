//
//  ChatListTableViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/30/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import SDWebImage

protocol SwopperProfileProtocol: class {
    func openSwopperProfile(user: User)
}

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    weak var delegate: SwopperProfileProtocol?
    var currentUser: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func updateCell(user: User){
        self.currentUser = user
        let picUrl = URL(string: Constants.GET_PROFILE_PIC_URL + user.profilePictureUrl!)
        if(picUrl != nil){
            self.profileImgV.sd_setImage(with: picUrl!, placeholderImage: UIImage(named: "profile_placeholder"))
        }
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        self.usernameLbl.text = user.username
        self.msgLbl.text = user.about
    }
    
    @IBAction func profileBtnTapped(_ sender: UIButton) {
        self.delegate?.openSwopperProfile(user: currentUser!)
    }
}
