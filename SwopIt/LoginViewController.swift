//
//  LoginViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/22/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseMessaging
import FirebaseCore
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordBottomView: UIView!

    @IBOutlet weak var usernameBottomView: UIView!
    @IBOutlet weak var passwordAvatarImageV: UIImageView!
    @IBOutlet weak var passwordActiveStateLbl: UILabel!
    @IBOutlet weak var usernameActiveStateLbl: UILabel!
    @IBOutlet weak var passwordImgV: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameImgV: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.onViewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    func onViewTapped(){
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.resetUsernameTextFieldUI()
        self.resetPasswordTextFieldUI()
    }
    @IBAction func login(_ sender: Any) {
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        guard let usrnm = usernameTextField.text else{
            Utils.showAlert(title: "SwopIt", msg: "Please enter username", vc: self)
            return
        }
        if(usrnm.characters.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter username", vc: self)
            return
        }
        guard let pwd = passwordTextField.text else{
            Utils.showAlert(title: "SwopIt", msg: "Please enter password", vc: self)
            return
        }
        if(pwd.characters.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter password", vc: self)
            return

        }
        self.authenticate(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authenticate(username: String, password: String){
        var token: String = ""
        if Utils.getDeviceToken() != nil {
            token = Utils.getDeviceToken()!
        }else if let fcmToken = FIRInstanceID.instanceID().token(){
            token = fcmToken
        }
        let params = ["Username": username, "Password":password, Constants.KEY_DEVICE_ID:token]
        
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.AUTHENTICATION_URL, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            print("Response \(resp)")
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                let usr = ModelFactory.createUser(dict: resp!)
                if(Utils.saveUserToPrefs(user: usr)){
                    self.present(MainTabsViewController(), animated: false, completion: {
                     // FIRMessaging.messaging().subscribe(toTopic: usr.username!)
                    })
                }
                else{
                    Utils.showAlert(title: "SwopIt", msg: "Cannot login please try again", vc: self)
                }
                
            }
            else{
                Utils.showAlert(title: "SwopIt", msg: "Cannot login please try again.", vc: self)
            }
        }
    }
    
    func updateUserNameTextFieldLeftImageView(image: UIImage){
        self.usernameImgV.image = image
    }
    func updatePasswordTextFieldLeftImageView(image: UIImage){
        self.passwordImgV.image = image
    }
    
    
    func resetPasswordTextFieldUI(){
        let normalColor = UIColor(colorLiteralRed: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: normalColor])
        self.passwordTextField.textColor = normalColor
        self.passwordAvatarImageV.image = UIImage(named: "lock_inactive")
        self.passwordActiveStateLbl.isHidden = true
        self.passwordBottomView.backgroundColor = normalColor
    }
    
    
    func resetUsernameTextFieldUI(){
        let normalColor = UIColor(colorLiteralRed: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: normalColor])
        self.usernameTextField.textColor = normalColor
        self.usernameImgV.image = UIImage(named: "avatar_inactive")
        self.usernameActiveStateLbl.isHidden = true
        self.usernameBottomView.backgroundColor = normalColor
    }
    
    @IBAction func goToSignUp(_ sender: Any) {
        self.present(SignupViewController(), animated: true) {
            
        }
    }
    @IBAction func usernameDidBeginEditing(_ sender: Any) {
        let editingColor = UIColor(colorLiteralRed: 19.0/255.0, green: 155.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: editingColor])
        self.usernameTextField.textColor = editingColor
        self.usernameImgV.image = UIImage(named:"avatar")
        self.usernameActiveStateLbl.isHidden = false
        self.usernameBottomView.backgroundColor = editingColor
        self.resetPasswordTextFieldUI()
        //        self.updatePasswordTextFieldLeftImageView(image: UIImage(named: "")!)
        //        self.updateUserNameTextFieldLeftImageView(image: UIImage(named: "")!)
    }
    
    @IBAction func passwordDidBeginEditing(_ sender: Any) {
        let editingColor = UIColor(colorLiteralRed: 19.0/255.0, green: 155.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: editingColor])
        self.passwordTextField.textColor = editingColor
        self.passwordAvatarImageV.image = UIImage(named: "lock_active")
        self.passwordActiveStateLbl.isHidden = false
        self.passwordBottomView.backgroundColor = editingColor
        self.resetUsernameTextFieldUI()
        //        self.updatePasswordTextFieldLeftImageView(image: UIImage(named: "")!)
        //        self.updateUserNameTextFieldLeftImageView(image: UIImage(named: "")!)
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false) { 
            
        }
    }
    
    @IBAction func togglePasswordVisibility(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
    }
    
    
}
