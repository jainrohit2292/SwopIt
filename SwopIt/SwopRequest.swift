//
//  SwopRequest.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 4/27/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class SwopRequest: NSObject {
    var date: String?
    var receiver : User?
    var sender : User?
    var receiverItems : [Item]?
    var senderItems : [Item]?
    var swopRequestId: String?
    var status: String?
    var swopType: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        if let dt = dict["Date"]{
            self.date = (dt as! String)
        }
        if let rcvrItems = dict["RecieverItems"]{
            self.receiverItems = ModelFactory.createItemsListFromArray(dict: rcvrItems as! [[String : AnyObject]])
        }
        if let sndrItems = dict["SenderItems"]{
            self.senderItems = ModelFactory.createItemsListFromArray(dict: sndrItems as! [[String : AnyObject]])
        }
        if let rcvr = dict["Reciever"]{
            self.receiver = User(dict: rcvr as! [String : AnyObject])
        }
        if let sndr = dict["Sender"]{
            self.sender = User(dict: sndr as! [String : AnyObject])
        }
        if let srId = dict["SwopRequestId"]{
            self.swopRequestId = (srId as! String)
        }
        if let st = dict["Status"]{
            self.status = (st as! String)
        }
        if let styp = dict["SwopType"]{
            self.swopType = (styp as! String)
        }

    }
}
