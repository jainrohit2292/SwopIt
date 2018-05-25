//
//  BecomeASwopperViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 6/2/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD

class BecomeASwopperViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var becomeASwopperTableView: UITableView!
    var swoppers = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeASwopperTableView.delegate = self
        self.becomeASwopperTableView.dataSource = self
        let cellnib = UINib(nibName: "SwopperTableViewCell", bundle: nil)
        self.becomeASwopperTableView.register(cellnib, forCellReuseIdentifier: "SwopperTableViewCell")
        self.getSwoppersByDistance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: SwopperTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SwopperTableViewCell", for: indexPath as IndexPath) as! SwopperTableViewCell
        cell.updateCell(user: self.swoppers[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.swoppers.count <= 0){
            self.becomeASwopperTableView.isHidden = true
        }
        else{
            self.becomeASwopperTableView.isHidden = false
        }
        return self.swoppers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 64.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let usr = self.swoppers[indexPath.row]
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil, userId: usr.userId!)
        self.present(profileVC, animated: false, completion: nil)
    }
    func getAllSwoppers(){
    
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func getSwoppersByDistance(){
        let params = ["UserId":Utils.getLoggedInUserId(), "Distance": Utils.getCurrentDistancePreference()]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_SWOPPERS_BY_DISTANCE, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(response?[Constants.KEY_RESPONSE_CODE] as! Int == 1){
                let users = response?[Constants.KEY_RESPONSE] as! [[String: AnyObject]]
                self.swoppers = [User]()
                for usr in users{
                    self.swoppers.append(User(dict: usr))
                }
            }
            else{
                self.swoppers = [User]()
            }
            self.becomeASwopperTableView.reloadData()
            
        }
    }

}
