//
//  Item.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/25/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class Item: NSObject {
    
    var category: String?
    var condition: String?
    var details: String?
    var itemId: String?
    var name: String?
    var postDate: String?
    var userId: String?
    var urls: [String] = [String]()
    var user: User?
    var distance: String?
    init(dict: [String: AnyObject]) {
        super.init()
        var itemsDict : [String: AnyObject]?
        if let iDict = dict["Item"]{
            itemsDict = (iDict as! [String: AnyObject])
        }
        if(itemsDict ==  nil){
            itemsDict = dict
        }
        if let cat = itemsDict?[Constants.KEY_CATEGORY] as? String{

                self.category = (cat as! String)
            
        }
        if let cond = itemsDict?[Constants.KEY_CONDITION]{
            self.condition = (cond as! String)
        }
        if let det = itemsDict?[Constants.KEY_DETAILS]{
            self.details = (det as! String)
        }
        if let nm = itemsDict?[Constants.KEY_NAME]{
            self.name = (nm as! String)
        }
        if let pd = itemsDict?[Constants.KEY_POST_DATE]{
            self.postDate = (pd as! String)
        }
        if let uid = itemsDict?[Constants.KEY_USER_ID]{
            self.userId = (uid as! String)
        }
        if let iid = itemsDict?[Constants.KEY_ITEM_ID]{
            self.itemId = (iid as! String)
        }
        if let deets = itemsDict?[Constants.KEY_DETAILS]{
            self.details = (deets as! String)
        }
        if let us = itemsDict?[Constants.KEY_URLS]{
            for url in us as! [String]{
                self.urls.append(url)
            }
        }
        if let uDict = itemsDict?["User"]{
            let userDict = uDict as! [String: AnyObject]
            self.user = User(dict: userDict)
        }
        
        if let dist = dict[Constants.KEY_DISTANCE]{
            self.distance = (dist as! String)
        }
        
    }
}
