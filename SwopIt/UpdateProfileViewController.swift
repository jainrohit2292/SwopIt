//
//  UpdateProfileViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/2/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD


class UpdateProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: EditProfileTextField!
    
    @IBOutlet weak var addressTextField: EditProfileTextField!
    
    @IBOutlet weak var contactInfoTextField: EditProfileTextField!
   
    @IBOutlet weak var aboutTextField: EditProfileTextField!
    
    @IBOutlet weak var moreTextField: EditProfileTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        self.nameTextField.text = (defaults.value(forKey: Constants.KEY_NAME) as! String)
        if let about = defaults.value(forKey: Constants.KEY_ABOUT){
            self.aboutTextField.text = (about as! String)
        }
        if let moreInfo = defaults.value(forKey: Constants.KEY_MORE_INFO){
            self.moreTextField.text = (moreInfo as! String)
        }
        if let addr = defaults.value(forKey: Constants.KEY_ADDRESS){
            self.addressTextField.text = (addr as! String)
        }
        let val = defaults.value(forKey: Constants.KEY_PHONE)
        print("Phone : \(val)")
        if let contactInfo = defaults.value(forKey: Constants.KEY_PHONE){
            self.contactInfoTextField.text = (contactInfo as! String)
        }
        self.addPlaceholderPadding()
        self.nameTextField.delegate = self
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.onViewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    func onViewTapped(){
        self.nameTextField.resignFirstResponder()
        self.moreTextField.resignFirstResponder()
        self.addressTextField.resignFirstResponder()
        self.contactInfoTextField.resignFirstResponder()
        self.addressTextField.resignFirstResponder()
        self.aboutTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateProfile(name: String, username: String, password: String, email: String, phone: String, about: String, moreInfo: String, address: String, latitude: String, longitude: String){
        let userId = Utils.getLoggedInUserId()
        let params = ["UserId": userId, "Name": name, "Password": password, "Username": username, "Email": email, "Phone": phone, "About": about, "MoreInfo": moreInfo, "Address": address, "Longitude": longitude, "Latitude": latitude]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.UPDATE_USER_URL, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            print("Response \(resp)")
            if((resp?["ResponseCode"] as! Int) == 1){
                if(Utils.saveUserToPrefs(user: ModelFactory.createUser(dict: resp!))){
                    
                }
            }

        }
    }
    func updateProfile(name: String, phone: String, about: String, moreInfo: String, address: String){
        let userId = Utils.getLoggedInUserId()
        let params = ["UserId": userId, "Name": name, "Phone":phone, "About": about, "MoreInfo": moreInfo, "Address": address]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.UPDATE_USER_URL, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            print("Response \(resp)")
            if((resp?["ResponseCode"] as! Int) == 1){
                if(Utils.saveUserToPrefs(user: ModelFactory.createUser(dict: resp!))){
                    
                }
            }
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func addPlaceholderPadding(){
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 2, height: 30))
        let paddingView2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 2, height: 30))
        let paddingView3 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 2, height: 30))
        let paddingView4 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 2, height: 30))
        let paddingView5 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 2, height: 30))
        self.nameTextField.leftView = paddingView
        self.nameTextField.leftViewMode = .always
        self.aboutTextField.leftView = paddingView2
        self.aboutTextField.leftViewMode = .always
        self.moreTextField.leftView = paddingView3
        self.moreTextField.leftViewMode = .always
        self.contactInfoTextField.leftView = paddingView4
        self.contactInfoTextField.leftViewMode = .always
        self.addressTextField.leftView = paddingView5
        self.addressTextField.leftViewMode = .always
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false) { 
            
        }
    }
    @IBAction func save(_ sender: Any) {
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        if((self.nameTextField.text?.characters.count)! > 10){
            Utils.showAlert(title: "SwopIt", msg: "Name Cannot be greater than 10 characters", vc: self)
            return
        }
        if((self.contactInfoTextField.text?.characters.count)! > 15){
            Utils.showAlert(title: "SwopIt", msg: "Contact Info Cannot be greater than 15 characters", vc: self)
            return
        }

        self.updateProfile(name: self.nameTextField.text!, phone: self.contactInfoTextField.text!, about: self.aboutTextField.text!, moreInfo: self.moreTextField.text!, address: self.addressTextField.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let currentCharacterCount = textField.text?.characters.count ?? 0
//        if (range.length + range.location > currentCharacterCount){
//            return false
//        }
//        let newLength = currentCharacterCount + string.characters.count - range.length
//        return newLength <= 10
        return true
    }
    @IBAction func contactDidBeginEditing(_ sender: Any) {
        self.viewTopConstraint.constant = -250
        self.viewBottomConstraint.constant = 250
        
    }
    @IBAction func contactDidEndEditing(_ sender: Any) {
        self.viewTopConstraint.constant = 0
        self.viewBottomConstraint.constant = 0
    }
    @IBAction func aboutDidBeginEditing(_ sender: Any) {
        self.viewTopConstraint.constant = -250
        self.viewBottomConstraint.constant = 250
    }
    @IBAction func aboutDidEndEditing(_ sender: Any) {
        self.viewTopConstraint.constant = 0
        self.viewBottomConstraint.constant = 0
    }

    @IBAction func moreDidBeginEditing(_ sender: Any) {
        self.viewTopConstraint.constant = -250
        self.viewBottomConstraint.constant = 250
    }
    
    @IBAction func moreDidEndEditing(_ sender: Any) {
        self.viewTopConstraint.constant = 0
        self.viewBottomConstraint.constant = 0
    }
    
}
