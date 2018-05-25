//
//  ChatListViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 4/27/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD


class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var chatsListTableView: UITableView!
    var chatListUsers = [User]()
    var delegate: SwopItTabBarHandlerProtocol?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: SwopItTabBarHandlerProtocol?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatsListTableView.delegate = self
        self.chatsListTableView.dataSource = self
        let cellnib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        self.chatsListTableView.register(cellnib, forCellReuseIdentifier: "ChatListTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllChatsForLoggedInUser()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: ChatListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath as IndexPath) as! ChatListTableViewCell
        cell.updateCell(user: self.chatListUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.chatListUsers.count <= 0){
            self.chatsListTableView.isHidden = true
        }
        else{
            self.chatsListTableView.isHidden = false
        }
        return self.chatListUsers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 64.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let chatVC = ChatViewController(nibName: "ChatViewController", bundle: nil, userId: Utils.getLoggedInUserId(), userId2: self.chatListUsers[indexPath.row].userId!, receiverName: self.chatListUsers[indexPath.row].username!)
        self.delegate?.presentVC(vc: chatVC)
    }
    func getAllChatsForLoggedInUser(){
        let params = ["UserId": Utils.getLoggedInUserId()]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_CHAT_LIST_BY_USER_ID, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(response?[Constants.KEY_RESPONSE_CODE] as! Int == 1){
            let users = response?[Constants.KEY_RESPONSE] as! [[String: AnyObject]]
            self.chatListUsers = [User]()
            for usr in users{
                self.chatListUsers.append(User(dict: usr))
            }
            }
            else{
                self.chatListUsers = [User]()
            }
            self.chatsListTableView.reloadData()
        }
    }
}
