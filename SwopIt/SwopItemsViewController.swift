//
//  SwopItemsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/3/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD

class SwopItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var itemsTableView: UITableView!
    var items: [Item] = [Item]()
    var receivedItem: Item?
    var receivedItems: [Item]?
    var requestReceiverItems: [Item]?
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, receivedItem: Item) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.receivedItem = receivedItem
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, requestReceiverItems: [Item]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.requestReceiverItems = requestReceiverItems
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, receivedItems: [Item]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.receivedItems = receivedItems
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        let cellnib2 = UINib(nibName: "SwoppedItemTableViewCell", bundle: nil)
        self.itemsTableView.register(cellnib2, forCellReuseIdentifier: "SwoppedItemTableViewCell")
        if(self.requestReceiverItems ==  nil){
            self.getAllItemsByUserId()
        }
        else{
            self.items = self.requestReceiverItems!
            self.itemsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: SwoppedItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SwoppedItemTableViewCell", for: indexPath as IndexPath) as! SwoppedItemTableViewCell
        cell.updateCell(item: self.items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(self.requestReceiverItems ==  nil){
            self.sendSwopRequest(item: self.items[indexPath.row])
        }
    }
    func sendSwopRequest(item: Item){
        if(!Utils.isUserLoggedin()){
            self.present(LoginViewController(), animated: false, completion: {
                
            })
            return
        }
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let itemId = item.itemId!
        var receiverId = self.receivedItems?[0].user?.userId!
        var receiverItemIds = ""
        var i = 0
        if(self.receivedItem != nil){
            receiverItemIds = self.receivedItem!.itemId!
            if(receiverId == nil){
                receiverId = self.receivedItem?.user?.userId!
            }
        }
        else{
        for ritem in self.receivedItems!{
            if(i < (self.receivedItems?.count)!){
                receiverItemIds = receiverItemIds + ritem.itemId! + ","
            }
            else{
                receiverItemIds = receiverItemIds + ritem.itemId!
            }
            i += 1
        }
        }
        var swopType = "Single"
        if(self.receivedItems != nil){
            swopType = "DS"
        }
        let params = ["Sender": Utils.getLoggedInUserId(), "Reciever": receiverId, "SwopType":swopType, "RecieverItems": receiverItemIds, "SenderItems": itemId]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.SEND_SWOP_REQUEST, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if((response?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                Utils.showAlertAndDismiss(title: "SwopIt", msg: "Request Sent Successfully!!", vc: self)
            }
            else{
                Utils.showAlert(title: "SwopIt", msg: "Unable to send request. Please try again.", vc: self)
            }
            
        }
    }
    func getAllItemsByUserId(){
        let url = Constants.GET_ITEM_BY_USER_ID_URL
        let params = [Constants.KEY_USER_ID :  Utils.getLoggedInUserId()]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                if(self.items.count <= 0 ){
                    Utils.showAlert(title: "SwopIt", msg: "No Items available to swop", vc: self)
                }
                self.itemsTableView.reloadData()
            }
        }
    }
    
   

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
