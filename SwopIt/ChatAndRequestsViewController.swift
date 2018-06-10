//
//  ChatAndRequestsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 4/27/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

protocol ChatDelegate {
    func onRequestAccepted(usrId: String?, usrId2: String, user1: User?, user2: User?)
}

class ChatAndRequestsViewController: UIViewController, ChatDelegate {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tabs: UIView!
    var tab: UITabBarController?
    
    var delegate: SwopItTabBarHandlerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabViews()
        Utils.setNewMessageCount(val: 0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMenu"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: SwopItTabBarHandlerProtocol) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    var chatListVC = ChatListViewController(nibName: "ChatListViewController", bundle: nil, delegate: nil)
    func initTabViews(){
        self.tab = UITabBarController()
        self.tab?.view.frame = CGRect(x:0.0, y:0.0, width: self.tabs.frame.width, height: self.tabs.frame.height)
        let chatListVC = ChatListViewController(nibName: "ChatListViewController", bundle: nil, delegate: self.delegate)
        
        let requestsVC = RequestsViewController(nibName: "RequestsViewController", bundle: nil, delegate: self.delegate!, chatDelegate: self)
        let vcsArray = [chatListVC, requestsVC]
        self.tab?.setViewControllers(vcsArray, animated: false)
        self.tab?.selectedIndex = 0
        self.segmentControl.selectedSegmentIndex = 0
        self.tabs.addSubview((self.tab?.view)!)
        self.tab?.tabBar.isHidden = true
    }
    @IBAction func onSegmentSelected(_ sender: Any) {
        self.tab?.selectedIndex = self.segmentControl.selectedSegmentIndex
    }
    func onRequestAccepted(usrId: String?, usrId2: String, user1: User?, user2: User?){
        let chatVC = ChatViewController(nibName: "ChatViewController", bundle: nil, userId: usrId!, userId2: usrId2, receiverName: (user2?.username!)!)
        self.delegate?.presentVC(vc: chatVC)
    
    }

}
