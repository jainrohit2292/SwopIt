//
//  SubCategory.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/4/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class SubCategory: NSObject {
    var id: String?
    var name: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        if  let id = dict[Constants.KEY_ID]{
            self.id =  (id as! String)
        }
        if let nm = dict[Constants.KEY_NAME]{
            self.name = (nm as! String)
        }
    }
    
}
