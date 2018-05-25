//
//  ModelFactory.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/25/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class ModelFactory: NSObject {

    static func createItemsList(dict: [String: AnyObject]) -> [Item]{
        var items = [Item]()
        let resp = dict[Constants.KEY_RESPONSE] as! [[String: AnyObject]]
        for elem in resp{
            items.append(Item(dict: elem))
        }
        return items
    }
    static func createItemsListFromArray(dict: [[String: AnyObject]]) -> [Item]{
        var items = [Item]()
        for elem in dict{
            items.append(Item(dict: elem))
        }
        return items
    }
    static func createUser(dict: [String: AnyObject]) -> User{
            return User(dict: dict)
    }
    static func createCategoriesList(dict: [String: AnyObject]) -> [Category]{
        var categories = [Category]()
        let resp = dict[Constants.KEY_RESPONSE] as! [[String: AnyObject]]
        for elem in resp{
            categories.append(Category(dict: elem))
        }
        return categories
    }
    
}
