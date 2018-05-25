//
//  RatingViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/15/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import FloatRatingView
import Cosmos
import MBProgressHUD
class RatingViewController: UIViewController{
    @IBOutlet weak var cosmosView: CosmosView!

    @IBOutlet weak var ratingView: UIView!
    
    var userId: String?
    var chatDelegate: ChatDelegate?
    var swopReq: SwopRequest?
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, userId: String, chatDelegate: ChatDelegate, swopRequest: SwopRequest) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userId = userId
        self.chatDelegate = chatDelegate
        self.swopReq = swopRequest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosView.didFinishTouchingCosmos = { rating in
            print("Here : \(rating)")
            MBProgressHUD.showAdded(to: self.view, animated: false)
            let params = ["UserId": self.userId!, "Rater": Utils.getLoggedInUserId(), "Rating": String(Int(rating))]
            Utils.httpCall(url: Constants.EVALUATE_SWOPPER_URL, params: params as [String : AnyObject]?, httpMethod: "POST", responseHandler: { (response) in
                MBProgressHUD.hide(for: self.view, animated: false)
                self.dismiss(animated: false, completion: { 
                    self.chatDelegate?.onRequestAccepted(usrId: self.swopReq?.sender?.userId, usrId2: (self.swopReq?.receiver?.userId)!, user1: self.swopReq?.sender, user2: self.swopReq?.receiver)
                })
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
