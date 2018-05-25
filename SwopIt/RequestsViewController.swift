//
//  RequestsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 4/27/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD
class RequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwopRequestProtocol {

    @IBOutlet weak var requestsTableView: UITableView!
    var swopRequests = [SwopRequest]()
    var delegate: SwopItTabBarHandlerProtocol?
    var chatDelegate: ChatDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellnib = UINib(nibName: "SwopRequestTableViewCell", bundle: nil)
        self.requestsTableView.register(cellnib, forCellReuseIdentifier: "SwopRequestTableViewCell")
        self.requestsTableView.delegate = self
        self.requestsTableView.dataSource = self
        self.getSwopRequests()

    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: SwopItTabBarHandlerProtocol, chatDelegate: ChatDelegate) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.delegate = delegate
        self.chatDelegate = chatDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(_tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       
            let cell: SwopRequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SwopRequestTableViewCell", for: indexPath as IndexPath) as! SwopRequestTableViewCell
            cell.updateCell(swopRequest: self.swopRequests[indexPath.row], delegate: self)
            cell.selectionStyle = .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.swopRequests.count <= 0){
            self.requestsTableView.isHidden = true
        }
        else{
            self.requestsTableView.isHidden = false
        }
       return self.swopRequests.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(self.swopRequests[indexPath.row].status == "Accept" || self.swopRequests[indexPath.row].status == "Reject"){
            return 95.0
        }
        return 137.0
    }
    
    func getSwopRequests(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        let params = [Constants.KEY_USER_ID : Utils.getLoggedInUserId()]
        Utils.httpCall(url: Constants.GET_SWOP_REQUESTS, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(resp![Constants.KEY_RESPONSE_CODE] as! Int == 1){
            let response = resp!["Response"]
            self.swopRequests = [SwopRequest]()
            for elem in response as! [[String: AnyObject]]{
                self.swopRequests.append(SwopRequest(dict: elem))
            }
            }
            self.requestsTableView.reloadData()
            print("Count \(self.swopRequests.count)")
            
        }
    }
    func acceptRequest(sr: SwopRequest){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
         let params = ["SwopRequestId" : sr.swopRequestId!,"Status": "Accept"]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.UPDATE_REQUEST_STATUS, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(resp![Constants.KEY_RESPONSE_CODE] as! Int == 1){
                self.getSwopRequests()
                let rvc = RatingViewController(nibName: "RatingViewController", bundle: nil, userId: (sr.sender?.userId!)!, chatDelegate: self.chatDelegate!, swopRequest: sr)
                rvc.modalPresentationStyle = .overCurrentContext
//                self.delegate?.presentVC(vc: rvc)
                self.present(rvc, animated: false, completion: {
                    
                })
                
                
            }
        }
    }
    func rejectRequest(sr: SwopRequest){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let params = ["SwopRequestId" : sr.swopRequestId!,"Status": "Reject"]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.UPDATE_REQUEST_STATUS, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(resp![Constants.KEY_RESPONSE_CODE] as! Int == 1){
                self.getSwopRequests()
//                let rvc = RatingViewController(nibName: "RatingViewController", bundle: nil, userId: (sr.sender?.userId!)!)
//                
//                rvc.modalPresentationStyle = .overCurrentContext
//                self.delegate?.presentVC(vc: rvc)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let req = self.swopRequests[indexPath.row]
        if(req.swopType == "DS"){
            let swopItmsVC =  SwopItemsViewController(nibName: "SwopItemsViewController", bundle: nil, requestReceiverItems: req.receiverItems!)
            self.delegate?.presentVC(vc: swopItmsVC)
        }
        else{
            self.getItemDetails(rowNum: indexPath.row)
        }
    }
    func getItemDetails(rowNum: Int){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let sReq =  self.swopRequests[rowNum]
        let itemm = sReq.senderItems?[0]
        let params = [Constants.KEY_ITEM_ID : itemm?.itemId!]
        let url = Constants.GET_ITEM_DETAIL_BY_ID
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            print("Response : \(resp)")
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                let itm = Item(dict: resp?[Constants.KEY_RESPONSE] as! [String: AnyObject])
                if(itm.distance ==  nil){
                    itm.distance = self.swopRequests[rowNum].receiverItems?[0].distance
                }
                if(itm.urls.count == 0){
                    itm.urls = (self.swopRequests[rowNum].receiverItems?[0].urls)!
                }
                if(itm.user ==  nil){
                    itm.user = self.swopRequests[rowNum].receiverItems?[0].user
                }
                let idvc = ItemDetailsViewController(nibName: "ItemDetailsViewController", bundle: nil, item: itm, isSwopRequest: true)
                self.delegate?.presentVC(vc: idvc)
            }
        }
    }
    func goToProfile(userId: String){
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil, userId: userId)
        self.delegate?.presentVC(vc: profileVC)
    }
}
