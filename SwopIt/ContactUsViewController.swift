//
//  ContactUsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/31/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD

class ContactUsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameBottomView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
   
    @IBOutlet weak var emailBottomView: UIView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var messageBottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContactUsViewController.onViewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    func onViewTapped(){
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.messageTextField.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func nameEditingDidBegin(_ sender: Any) {
        self.nameBottomView.backgroundColor = UIColor(colorLiteralRed: 37.0/255.0, green: 135.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
    @IBAction func nameEditingDidEnd(_ sender: Any) {
        self.nameBottomView.backgroundColor = UIColor(colorLiteralRed: 86.0/255.0, green: 87.0/255.0, blue: 88.0/255.0, alpha: 1.0)
    }
    @IBAction func emailEditingDidBegin(_ sender: Any) {
        self.emailBottomView.backgroundColor = UIColor(colorLiteralRed: 37.0/255.0, green: 135.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
    @IBAction func emailEditingDidEnd(_ sender: Any) {
        self.emailBottomView.backgroundColor = UIColor(colorLiteralRed: 86.0/255.0, green: 87.0/255.0, blue: 88.0/255.0, alpha: 1.0)
    }
    @IBAction func messageEditingDidBegin(_ sender: Any) {
        self.messageBottomView.backgroundColor = UIColor(colorLiteralRed: 37.0/255.0, green: 135.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
    @IBAction func messageEditingDidEnd(_ sender: Any) {
        self.messageBottomView.backgroundColor = UIColor(colorLiteralRed: 86.0/255.0, green: 87.0/255.0, blue: 88.0/255.0, alpha: 1.0)
    }
    @IBAction func submitResponse(_ sender: Any) {
        if((nameTextField.text?.characters.count)! <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Enter Name Please", vc: self)
            return
        }
        if((emailTextField.text?.characters.count)! <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Enter Email Please", vc: self)
            return
        }
        if((messageTextField.text?.characters.count)! <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Enter Message Please", vc: self)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        MBProgressHUD.hide(for: self.view, animated: false)
        Utils.showAlertAndDismiss(title: "SwopIt", msg: "Thanks!", vc: self)
    }

}
