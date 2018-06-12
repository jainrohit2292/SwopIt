//
//  SwopperProfileViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/2/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import SDWebImage

class SwopperProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    var user : User?
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageV.layer.cornerRadius = self.profileImageV.frame.width/2
        self.profileImageV.clipsToBounds = true
        self.loadProfileInfo()
    }
    
    func loadProfileInfo(){
        self.nameLbl.text = self.user?.username!//Utils.getLoggedInUserName()
        if let profUrl = self.user!.profilePictureUrl{
            print("Profile Url : \(profUrl)")
            self.profileImageV.sd_setImage(with: URL(string: Constants.GET_PROFILE_PIC_URL + profUrl), placeholderImage: UIImage(named:"profile_placeholder"))
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

