//
//  RedeemCoinsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/17/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD

class RedeemCoinsViewController: UIViewController {

    @IBOutlet weak var totalCoinsLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var coinTextField: UITextField!
    
    @IBOutlet weak var bankNameTextField: UITextField!
    
    @IBOutlet weak var accountNoTextField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCoins()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sendRedeemRequest(_ sender: Any) {
        if((self.nameTextField.text?.characters.count)! <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter name", vc: self)
            return
        }
        if((self.coinTextField.text?.characters.count)! <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter number of coins.", vc: self)
            return
        }
        let chars = (self.coinTextField.text)
        if let intCoin = Int(chars!){
            if(intCoin <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Number of coins entered must be greater than zero.", vc: self)
            return
            }
        }
        if((self.bankNameTextField.text?.characters.count)! <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter bank name.", vc: self)
            return
        }
        if((self.accountNoTextField.text?.characters.count)! <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter account number.", vc: self)
            return
        }
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        if(!Utils.isEligibleToRedeemCoins(numOfCoins: Int(self.coinTextField.text!)!)){
            Utils.showAlert(title: "SwopIt", msg: "You do not have enough number of coins", vc: self)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        let params = ["Name": self.nameTextField.text, "Coins":self.coinTextField.text, "BankName": self.bankNameTextField.text, "AccountNumber": self.accountNoTextField.text]
        Utils.httpCall(url: Constants.REDEEM_COINS_URL, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            print("Response : \(response)")
            if(response != nil){
                if((response?["ResponseCode"] as! Int) == 1){
                    Utils.showAlertAndDismiss(title: "Swop It", msg: "Coins redeemed successfully!", vc: self)
                    Utils.updateNumOfCoins(numOfCoins: Int(self.coinTextField.text!)!)
                    return
                }
                
            }
            Utils.showAlertAndDismiss(title: "Swop It", msg: "Cannot redeem coins.", vc: self)
        }
    }
    
    func updateCoins(){
        let params = ["UserId": Utils.getLoggedInUserId()]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_USER_DETAILS_BY_ID, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if((response?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                Utils.saveUserToPrefs(user: ModelFactory.createUser(dict: response!))
                let numCoins = Utils.getCurrNumOfCoins()
                if(numCoins == nil){
                    self.totalCoinsLbl.text = "Coins : 0"
                }
                else{
                    self.totalCoinsLbl.text = "Coins : \(Utils.getCurrNumOfCoins()!)"
                }
            }
        }
        
        
    }


    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
