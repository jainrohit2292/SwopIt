//
//  User.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/21/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class User: NSObject {
    var userId: String?
    var name: String?
    var username: String?
    var email: String?
    var phone: String?
    var about: String?
    var moreInfo: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var profilePictureUrl: String?
    var coins: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        var userDict: [String: AnyObject]?
        if let rDict =  dict[Constants.KEY_RESPONSE]{
         userDict = (rDict as! [String: AnyObject])
        }
        if(userDict == nil){
            userDict = dict
        }
        if let usrId = userDict?[Constants.KEY_USER_ID]{
            self.userId = (usrId as! String)
        }
        if let nm = userDict?[Constants.KEY_NAME]{
            self.name = (nm as! String)
        }
        if let usrnm = userDict?[Constants.KEY_USERNAME]{
            self.username = (usrnm as! String)
        }
        if let mail = userDict?[Constants.KEY_EMAIL]{
            self.email = (mail as! String)
        }
        if let abt = userDict?[Constants.KEY_ABOUT]{
            self.about =  (abt as! String)
        }
        if let moreInf = userDict?[Constants.KEY_MORE_INFO]{
            self.moreInfo = (moreInf as! String)
        }
        if let addr = userDict?[Constants.KEY_ADDRESS]{
            self.address = (addr as! String)
        }
        if let lat = userDict?[Constants.KEY_LATITUDE]{
            self.latitude = (lat as! String)
        }
        if let long = userDict?[Constants.KEY_LONGITUDE]{
            self.longitude = (long as! String)
        }
        if let profPicUrl = userDict?[Constants.KEY_PROFILE_PICTURE]{
            self.profilePictureUrl = (profPicUrl as! String)
        }
        if let phn = userDict?[Constants.KEY_PHONE]{
            self.phone = (phn as! String)
        }
        if let cns = userDict?["Coins"]{
            //if(cns != "<null>"){
                self.coins = (cns as? String)
           // }
        }

    }
}
