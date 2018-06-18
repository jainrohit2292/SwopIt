//
//  SignupViewController.swift
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

class SignupViewController: UIViewController {

    @IBOutlet weak var addressBottomView: UIView!
    @IBOutlet weak var addressImgV: UIImageView!
    @IBOutlet weak var addressActiveLbl: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailAvatarImageV: UIImageView!

    @IBOutlet weak var passwordAvatarImageV: UIImageView!
    @IBOutlet weak var passwordActiveLbl: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailActiveLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameAvatarImageV: UIImageView!
    @IBOutlet weak var usernameActiveLbl: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    var usernameAvailable = false
    
    @IBOutlet weak var mobileNumberBottomView: UIView!
    @IBOutlet weak var emailBottomView: UIView!
    @IBOutlet weak var usernameBottomView: UIView!
    @IBOutlet weak var mobileNumberAvatarImageV: UIImageView!
    @IBOutlet weak var mobileNumberActiveLbl: UILabel!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var passwordBottomView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.onViewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    func onViewTapped(){
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.mobileNumberTextField.resignFirstResponder()
        self.resetUsernameTextFieldUI()
        self.resetPasswordTextFieldUI()
        self.resetEmailTextFieldUI()
        self.resetMobileNumberTextFieldUI()
         self.resetAddressTextFieldUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func register(name: String, username:String, email: String, password: String, mobileNumber: String){
        
        var token: String = ""
        if Utils.getDeviceToken() != nil {
            token = Utils.getDeviceToken()!
        }else if let fcmToken = FIRInstanceID.instanceID().token(){
            token = fcmToken
        }
        
        let params = [Constants.KEY_NAME: name, Constants.KEY_USERNAME:username, Constants.KEY_EMAIL: email, Constants.KEY_PASSWORD:password,Constants.KEY_PHONE:mobileNumber, Constants.KEY_ABOUT:"", Constants.KEY_MORE_INFO:"", Constants.KEY_ADDRESS:self.addressTextField.text!, Constants.KEY_LONGITUDE:String(Utils.getUserLocationFromPrefs().longitude), Constants.KEY_LATITUDE:String(Utils.getUserLocationFromPrefs().latitude), Constants.KEY_DEVICE_ID: token]
        
        
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.REGISTRATION_URL, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                let usr = ModelFactory.createUser(dict: resp!)
                if(Utils.saveUserToPrefs(user: usr)){
                    FIRMessaging.messaging().subscribe(toTopic: usr.username!)
                    Utils.showAlert(title: "SwopIt", msg: "Registered successfully!", vc: self)
                    // TODO: DismissToRootViewController and present Profile screen
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let rootVC = appDelegate.window?.rootViewController
                    let presentedVC = rootVC?.presentedViewController
                    //while(presentedVC != nil){
                    //    presentedVC = presentedVC?.presentedViewController
                    //}
                    presentedVC?.presentingViewController?.dismiss(animated: false, completion: {
                        rootVC?.present(ProfileViewController(), animated: false, completion: nil)
                    })
                    
              //      presentedVC?.dismiss(animated: false, completion: {
              //          self.dismiss(animated: false, completion: nil)
              //      })
                    
                    
                }
                else{
                    Utils.showAlert(title: "SwopIt", msg: "Cannot signup please try again", vc: self)
                }
            }
            else{
                Utils.showAlert(title: "SwopIt", msg: "Cannot signup please try again", vc: self)
            }
        }
    }
    @IBAction func goToLogin(_ sender: Any) {
        self.present(LoginViewController(), animated: false) { 
            
        }
    }

    
    @IBAction func usernameDidEndEditing(_ sender: Any) {
        let params = ["Username": usernameTextField.text!]
        Utils.httpCall(url: Constants.CHECK_USER_AVAILABILITY_URL, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            if((resp?["ResponseCode"] as! Int) == 1){
                self.usernameAvailable = true
            }
            else{
                self.usernameAvailable = false
            }
        }
    }
    @IBAction func usernameDidBeginEiditing(_ sender: Any) {
        let editingColor = UIColor(colorLiteralRed: 19.0/255.0, green: 155.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: editingColor])
        self.usernameTextField.textColor = editingColor
        self.usernameAvatarImageV.image = UIImage(named:"avatar")
        self.usernameActiveLbl.isHidden = false
        self.usernameBottomView.backgroundColor = editingColor
        self.resetPasswordTextFieldUI()
        self.resetEmailTextFieldUI()
        self.resetMobileNumberTextFieldUI()
         self.resetAddressTextFieldUI()
    }
    @IBAction func emailDidBeginEditing(_ sender: Any) {
        let editingColor = UIColor(colorLiteralRed: 19.0/255.0, green: 155.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: editingColor])
        self.emailTextField.textColor = editingColor
        self.emailAvatarImageV.image = UIImage(named: "mail_active")
        self.emailBottomView.backgroundColor = editingColor
        self.emailActiveLbl.isHidden = false
        self.resetUsernameTextFieldUI()
        self.resetPasswordTextFieldUI()
        self.resetMobileNumberTextFieldUI()
        self.resetAddressTextFieldUI()
         self.resetAddressTextFieldUI()
    }
    @IBAction func mobileNumberDidBeginEditing(_ sender: Any) {
        let editingColor = UIColor(colorLiteralRed: 19.0/255.0, green: 155.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: "Mobile Number", attributes: [NSForegroundColorAttributeName: editingColor])
        self.mobileNumberTextField.textColor = editingColor
        self.mobileNumberAvatarImageV.image = UIImage(named: "cell_active")
        self.mobileNumberBottomView.backgroundColor = editingColor
        self.mobileNumberActiveLbl.isHidden = false
        self.resetPasswordTextFieldUI()
        self.resetUsernameTextFieldUI()
        self.resetEmailTextFieldUI()
         self.resetAddressTextFieldUI()
    }
    
    @IBAction func passwordDidBeginEditing(_ sender: Any) {
        let editingColor = UIColor(colorLiteralRed: 19.0/255.0, green: 155.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: editingColor])
        self.passwordTextField.textColor = editingColor
         self.passwordAvatarImageV.image = UIImage(named: "lock_active")
        self.passwordBottomView.backgroundColor = editingColor
        self.passwordActiveLbl.isHidden = false
        self.resetMobileNumberTextFieldUI()
        self.resetUsernameTextFieldUI()
        self.resetEmailTextFieldUI()
         self.resetAddressTextFieldUI()
    }
    
    func resetPasswordTextFieldUI(){
        let normalColor = UIColor(colorLiteralRed: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: normalColor])
        self.passwordTextField.textColor = normalColor
        self.passwordActiveLbl.isHidden = true
        self.passwordAvatarImageV.image = UIImage(named: "lock_inactive")
        self.passwordBottomView.backgroundColor = normalColor
    }
    func resetEmailTextFieldUI(){
        let normalColor = UIColor(colorLiteralRed: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: normalColor])
        self.emailTextField.textColor = normalColor
        self.emailActiveLbl.isHidden = true
        self.emailAvatarImageV.image = UIImage(named: "mail_inactive")
        self.emailBottomView.backgroundColor = normalColor
    }
    func resetMobileNumberTextFieldUI(){
        let normalColor = UIColor(colorLiteralRed: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: "Mobile Number", attributes: [NSForegroundColorAttributeName: normalColor])
        self.mobileNumberTextField.textColor = normalColor
        self.mobileNumberActiveLbl.isHidden = true
        self.mobileNumberAvatarImageV.image = UIImage(named: "cell_inactive")
        self.mobileNumberBottomView.backgroundColor = normalColor
    }
    
    
    func resetUsernameTextFieldUI(){
        let normalColor = UIColor(colorLiteralRed: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: normalColor])
        self.usernameTextField.textColor = normalColor
        self.usernameAvatarImageV.image = UIImage(named: "avatar_inactive")
        self.usernameActiveLbl.isHidden = true
        self.usernameBottomView.backgroundColor = normalColor
    }
    func resetAddressTextFieldUI(){
        let normalColor = UIColor(colorLiteralRed: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.addressTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: normalColor])
        self.addressTextField.textColor = normalColor
        self.addressActiveLbl.isHidden = true
        self.addressImgV.image = UIImage(named: "mail_inactive")
        self.addressBottomView.backgroundColor = normalColor
    }
    
    func isEmailValid() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.emailTextField.text)
    }
    @IBAction func signUp(_ sender: Any) {
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        guard let usrnam = usernameTextField.text else{
            Utils.showAlert(title: "SwopIt", msg: "Please enter username", vc: self)
            return
        }
        if(usrnam.characters.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter username", vc: self)
            return
        }
        guard let email = emailTextField.text else{
            Utils.showAlert(title: "SwopIt", msg: "Please enter email", vc: self)
            return
        }
        if(email.characters.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter email", vc: self)
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
        guard let mobNum = mobileNumberTextField.text else{
            Utils.showAlert(title: "SwopIt", msg: "Please enter mobile number", vc: self)
            return
        }
        if(mobNum.characters.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter mobile number", vc: self)
            return
        }
        let locLat = Float(Utils.getUserLocationFromPrefs().latitude)
        let locLong = Float(Utils.getUserLocationFromPrefs().longitude)
        
//        if(locLat == 0 && locLong == 0){
//            SwopItLocationManager.getInstance().requestLocationUpdate()
//            Utils.showAlert(title: "SwopIt", msg: "Please turn on GPS to get location and try again", vc: self)
//        }
        if(!self.isEmailValid()){
            Utils.showAlert(title: "SwopIt", msg: "Please enter a valid email address.", vc: self)
            return
        }
        if(!usernameAvailable){
            Utils.showAlert(title: "SwopIt", msg: "Username not available", vc: self)
            return
        }
    self.register(name: "", username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, mobileNumber: self.mobileNumberTextField.text!)
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    @IBAction func togglePasswordVisibility(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
    }
    @IBAction func addressEditingDidBegin(_ sender: Any) {
        let editingColor = UIColor(colorLiteralRed: 19.0/255.0, green: 155.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: editingColor])
        self.addressTextField.textColor = editingColor
        self.addressImgV.image = UIImage(named: "mail_active")
        self.addressBottomView.backgroundColor = editingColor
        self.addressActiveLbl.isHidden = false
        self.resetUsernameTextFieldUI()
        self.resetPasswordTextFieldUI()
        self.resetMobileNumberTextFieldUI()
        self.resetEmailTextFieldUI()
    }
    
}
