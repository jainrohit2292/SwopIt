//
//  Category.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/4/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class Category: NSObject {
    var id: String?
    var name: String?
    var subCategories:[SubCategory]?
    
    init(dict: [String: AnyObject]){
        super.init()
        if  let id = dict[Constants.KEY_ID]{
            self.id =  (id as! String)
        }
        if let nm = dict[Constants.KEY_NAME]{
            self.name = (nm as! String)
        }
        if let subCats = dict[Constants.KEY_SUBCATEGORY]{
            self.subCategories = [SubCategory]()
            for subCat in (subCats as! [[String: AnyObject]]){
                self.subCategories?.append(SubCategory(dict: subCat))
            }
        }
    }
}
