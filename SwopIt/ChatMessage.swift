//
//  ChatMessage.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/31/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class ChatMessage: NSObject {
    var chatId: String?
    var dateStr: String?
    var message: String?
    var receiver: String?
    var receiverProfilePicUrl: String?
    var sender: String?
    var senderProfilePicUrl: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        if let chid = dict["ChatId"]{
            self.chatId = (chid as! String)
        }
        if let dstr = dict["Date"]{
            self.dateStr = (dstr as! String)
        }
        if let msg = dict["Message"]{
            self.message = (msg as! String)
        }
        if let rcvr = dict["Reciever"]{
            self.receiver = (rcvr as! String)
        }
        if let rpp = dict["RecieverProfilePic"]{
            self.receiverProfilePicUrl = (rpp as! String)
        }
        if let sndr = dict["Sender"]{
            self.sender = (sndr as! String)
        }
        if let spp = dict["SenderProfilePic"]{
            self.senderProfilePicUrl = (spp as! String)
        }
    }
}
