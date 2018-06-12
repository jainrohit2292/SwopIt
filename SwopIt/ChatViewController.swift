//
//  ChatViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/15/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD
import JSQMessagesViewController
import SDWebImage

class ChatViewController: JSQMessagesViewController  {
    
    @IBOutlet weak var topView: UIView!
    var messages = [JSQMessage]()
    var chatMessages = [ChatMessage]()
    var userId : String?
    var userId2 : String?
    var receiverName : String?
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var loadingInProcess = false
    var requestTimer: Timer!
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, userId: String, userId2: String, receiverName: String) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userId = userId
        self.userId2 = userId2
        self.receiverName = receiverName
        self.senderId = userId
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = self.userId
        self.senderDisplayName = "Chat"
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
         self.collectionView?.collectionViewLayout.sectionInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        
        self.addViewOnTop()
        self.getAllChatMessages()
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    func addViewOnTop() {
        let selectableView = UIView(frame: CGRect(x: 0, y:0, width: self.view.bounds.width, height: 70))
        selectableView.backgroundColor = .white
        let randomViewLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2, y: 30, width: 100, height: 16))
        randomViewLabel.text = self.receiverName //"Chat"
        randomViewLabel.textColor =  UIColor(colorLiteralRed: 37.0/255.0, green: 135.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        
        
        let btn = UIButton(frame: CGRect(x: 8.0, y: 30.0, width: 30.0, height: 30.0))
//        btn.imageView?.image = UIImage(named: "back_icon")
        btn.setImage(UIImage(named:"back_icon"), for: .normal)
        btn.addTarget(self, action: #selector(goBack),for: .touchUpInside)
        selectableView.addSubview(btn)
        selectableView.addSubview(randomViewLabel)
        view.addSubview(selectableView)
    }
    func goBack(sender: UIButton!) {
       self.dismiss(animated: false, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getAllChatMessagesInBackground), userInfo: nil, repeats: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        requestTimer.invalidate()
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath))
        return CGSize(width: size.width, height: size.height + 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let customAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) as! JSQMessagesCollectionViewLayoutAttributes
        let width = customAttributes.messageBubbleContainerViewWidth
        if (width <= 140) {
            customAttributes.messageBubbleContainerViewWidth = 140
        }
        cell.apply(customAttributes)
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == self.userId {
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
    }
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    func updateUsers(userId: String?, userId2: String?, user1: User?, user2: User?){
        self.userId = userId
        self.userId2 = userId2
           }    
    
    func getAllChatMessagesInBackground(){
        
        if(!self.loadingInProcess){
            print("request called")
        let params = ["UserId": self.userId, "User2Id": self.userId2]
        Utils.httpCall(url: Constants.GET_CHAT_BY_TWO_USERS, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            self.chatMessages = [ChatMessage]()
            self.messages = [JSQMessage]()
            if(response == nil){
                return
            }
            let chatMsgs = response?[Constants.KEY_RESPONSE] as? [[String: AnyObject]]
            if(chatMsgs == nil){
                return
            }
            for msg in chatMsgs!{
                let chatMsg = ChatMessage(dict: msg)
                self.chatMessages.append(chatMsg)
                let date = Date(timeIntervalSince1970: chatMsg.timeStamp!)
                let msgg = JSQMessage(senderId: chatMsg.sender , senderDisplayName: "" , date: date, text:chatMsg.message )
                self.messages.append(msgg!)
            }
            self.finishReceivingMessage()
            self.collectionView.reloadData()
            print("Chat Messages Count : \(self.chatMessages.count)")
        }
        
        }
    }
    
    
    func getAllChatMessages(){
        self.loadingInProcess = true
        let params = ["UserId": self.userId, "User2Id": self.userId2]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_CHAT_BY_TWO_USERS, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            self.loadingInProcess = false
            self.chatMessages = [ChatMessage]()
            self.messages = [JSQMessage]()
            let chatMsgs = response?[Constants.KEY_RESPONSE] as! [[String: AnyObject]]
            for msg in chatMsgs{
                let chatMsg = ChatMessage(dict: msg)
                self.chatMessages.append(chatMsg)
                let date = Date(timeIntervalSince1970: chatMsg.timeStamp!)
                let msgg = JSQMessage(senderId: chatMsg.sender , senderDisplayName: chatMsg.sender , date: date, text:chatMsg.message )
                self.messages.append(msgg!)
            }
            self.finishReceivingMessage()
            self.collectionView.reloadData()
            print("Chat Messages Count : \(self.chatMessages.count)")
            
            
        }
    }
    func sendChatMessage(text: String){
        let params = ["Sender": userId, "Reciever": userId2, "Message": text]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        self.loadingInProcess = true
        Utils.httpCall(url: Constants.SEND_CHAT_MSG, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            self.loadingInProcess = false
            self.getAllChatMessages()
        }
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!){
        print("Here!")
        self.sendChatMessage(text: text)
        self.finishSendingMessage()
    }
    
}
