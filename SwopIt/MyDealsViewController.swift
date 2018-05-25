//
//  MyDealsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/15/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyDealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemProtocol {

    @IBOutlet weak var myItemsTableView: UITableView!
    
    var items: [Item] = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myItemsTableView.delegate = self
        self.myItemsTableView.dataSource = self
        let cellnib = UINib(nibName: "ItemsListTableViewCell", bundle: nil)
        self.myItemsTableView.register(cellnib, forCellReuseIdentifier: "ItemsListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getItemsByUserId()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(_tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(indexPath.row < self.items.count){
            let cell: ItemsListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemsListTableViewCell", for: indexPath as IndexPath) as! ItemsListTableViewCell
            cell.updateCell(item: self.items[indexPath.row], indexPath: indexPath, delegate: self)
            cell.selectionStyle = .none
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.items.count <= 0){
            self.myItemsTableView.isHidden = true
            return 0
        }
        else{
            self.myItemsTableView.isHidden = false
            return (self.items.count)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(indexPath.row < self.items.count){
            return 322
        }
        return 49.0
    }
    func getItemsByUserId(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network.", vc: self)
            return
        }
        let url = Constants.GET_ITEM_BY_USER_ID_URL
        print("User Id : \(Utils.getLoggedInUserId())")
        var params = [Constants.KEY_USER_ID: Utils.getLoggedInUserId()]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.myItemsTableView.reloadData()
            }
            else{
                self.items = [Item]()
                self.myItemsTableView.reloadData()
            }
        }
    }

    func goToItemDetails(item: Item, indexPath: IndexPath){
        self.getItemDetails(itemId: item.itemId!, rowNum: indexPath.row)
    }
    func goToUserProfile(userId : String){
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil, userId: userId)
        self.present(profileVC, animated: false, completion: nil)

    }
    func getItemDetails(itemId: String, rowNum: Int){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let params = [Constants.KEY_ITEM_ID : itemId]
        let url = Constants.GET_ITEM_DETAIL_BY_ID
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            print("Response : \(resp)")
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                let itm = Item(dict: resp?[Constants.KEY_RESPONSE] as! [String: AnyObject])
                if(itm.distance ==  nil){
                    if(self.items[rowNum].distance == nil){
                        itm.distance = "0"
                    }
                    else{
                        itm.distance = self.items[rowNum].distance!
                    }
                }
                if(itm.urls.count == 0){
                    itm.urls = self.items[rowNum].urls
                }
                if(itm.user ==  nil){
                    itm.user = self.items[rowNum].user
                }
                let idvc = ItemDetailsViewController(nibName: "ItemDetailsViewController", bundle: nil, item: itm)
                self.present(idvc, animated: false, completion: nil)
            }
        }
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

}
