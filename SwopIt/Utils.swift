//
//  Utils.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/12/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class Utils: NSObject {
    
    
    static func httpCall(url: String, params:[String: AnyObject]?, httpMethod: String, responseHandler: @escaping ([String: AnyObject]?) -> Void){
        
        var req = URLRequest(url: URL(string: url)!)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = httpMethod
        if(params != nil){
            req.httpBody = try!JSONSerialization.data(withJSONObject: params!, options: [])
        }
        Alamofire.request(req).responseJSON { (response) in
            print("Response : \(response)")
            if(response.data != nil){
                let resp = try?JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:AnyObject]
                responseHandler(resp)
            }
        }
        
    }
    
    static func uploadBinaryStream(url: String, params:Data?, httpMethod: String, responseHandler: @escaping ([String: AnyObject]?) -> Void){
        
        var req = URLRequest(url: URL(string: url)!)
        req.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        req.httpMethod = httpMethod
        if(params != nil){
            req.httpBody = params!//try!JSONSerialization.data(withJSONObject: params!, options: [])
        }
        Alamofire.request(req).responseJSON { (response) in
            
            if(response.data != nil){
                let resp = try?JSONSerialization.jsonObject(with: response.data!, options: []) as! [String:AnyObject]
                responseHandler(resp)
            }
        }
        
    }
    
    
    static func getCurrentDistancePreference() -> String?{
        let defaults = UserDefaults.standard
        let dist =  (defaults.value(forKey: Constants.KEY_DISTANCE) as? String)
        return dist
    }
    static func setCurrentDistancePreference(val: Float){
        let defaults = UserDefaults.standard
        defaults.set(String(val), forKey: Constants.KEY_DISTANCE)
    }
    
    static func getDeviceToken() -> String?{
        let defaults = UserDefaults.standard
        let dist =  (defaults.value(forKey: Constants.KEY_DEVICE_TOKEN) as? String)
        return dist
    }
    static func setDeviceToken(val: String){
        let defaults = UserDefaults.standard
        defaults.set(String(val), forKey: Constants.KEY_DEVICE_TOKEN)
    }
    
    static func getNewMessageCount() -> String?{
        let defaults = UserDefaults.standard
        let dist =  (defaults.value(forKey: Constants.KEY_NEW_MESSAGE_COUNT) as? String)
        return dist
    }
    static func setNewMessageCount(val: Int){
        let defaults = UserDefaults.standard
        defaults.set(String(val), forKey: Constants.KEY_NEW_MESSAGE_COUNT)
    }
    
    static func upload(url: String, filename: String, image: UIImage, responseHandler: @escaping ([String: AnyObject]?) -> Void){
        
        let scaledImg = Utils.imageWithImage(image: image, scaledToSize: CGSize(width: 100, height: 100))
        let imgData = UIImageJPEGRepresentation(image, 1.0)!
        print("Image Data length \(imgData.count)")
        
        let rawImageDataProvider = 
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgData , withName: filename, fileName: filename+".png", mimeType: "image/png")
            
        }, to: url, encodingCompletion: { (result) in
            print("Result : \(result)")
            responseHandler(["":"" as AnyObject])
        })
    }
    static func saveUserToPrefs(user: User) -> Bool{
        let defaults = UserDefaults.standard
        defaults.set(user.userId!, forKey: Constants.KEY_USER_ID)
        defaults.set(user.about!, forKey: Constants.KEY_ABOUT)
        defaults.set(user.email!, forKey: Constants.KEY_EMAIL)
        defaults.set(user.name!, forKey: Constants.KEY_NAME)
        defaults.set(user.moreInfo, forKey: Constants.KEY_MORE_INFO)
        defaults.set(user.address, forKey: Constants.KEY_ADDRESS)
        defaults.set(user.phone, forKey: Constants.KEY_PHONE)
        defaults.set(user.profilePictureUrl, forKey: Constants.KEY_PROFILE_PICTURE)
        defaults.set(user.username, forKey: Constants.KEY_USERNAME)
        if(user.coins == nil){
            defaults.set("0", forKey: "Coins")
        }
        else{
            defaults.set(user.coins!, forKey: "Coins")
        }
        return true
    }
    static func getCurrNumOfCoins() -> Int?{
        let defaults = UserDefaults.standard
        let coinsVal =  defaults.value(forKey: "Coins")
        print("Current Number of Coins = \(coinsVal!)")
//        if let cns = defaults.value(forKey: "Coins"){
//            return (cns as! Int)
//        }
        var strVal = coinsVal as! String
        return Int(strVal)
//        return Int(0)
    }
    static func isEligibleToRedeemCoins(numOfCoins: Int) -> Bool{
        let currCoins = getCurrNumOfCoins()
        if(currCoins != nil){
            if(currCoins! < numOfCoins){
                return false
            }
            return true
        }
        return false
    }
    static func updateNumOfCoins(numOfCoins: Int){
        let currCoins = getCurrNumOfCoins()
        
        if(currCoins != nil){
            let defaults = UserDefaults.standard
            defaults.set(String(currCoins! - numOfCoins), forKey: "Coins")
            let params = ["UserId": Utils.getLoggedInUserId(), "Coins": String((currCoins! - numOfCoins))]
            Utils.httpCall(url: Constants.UPDATE_COINS_URL, params: params as [String : AnyObject]?, httpMethod: "POST", responseHandler: { (response) in

            })
        }
        
    }
    static func getLoggedInUserName() -> String{
        let defaults = UserDefaults.standard
        guard  let nm = defaults.value(forKey: Constants.KEY_USERNAME) else {
            return ""
        }
        return (nm as! String)
    }
    static func getLoggedInUserProfilePictureUrl() -> String{
        let defaults = UserDefaults.standard
        guard  let nm = defaults.value(forKey: Constants.KEY_PROFILE_PICTURE) else {
            return ""
        }
        return (nm as! String)
    }
    static func showAlert(title: String, msg: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            
            
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    static func showAlertAndDismiss(title: String, msg: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            vc.dismiss(animated: false, completion: nil)
            
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func getLoggedInUserId() -> String{
        let defaults = UserDefaults.standard
        guard let userId = defaults.value(forKey: Constants.KEY_USER_ID) else{
            return ""
        }
        return (userId as! String)
    }
    
    static func getDeviceId() -> String{
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    static func getDeviceSize() -> CGSize{
        return UIScreen.main.bounds.size
    }
    
    static func saveLocationToPrefs(loc: CLLocationCoordinate2D){
        let defaults = UserDefaults.standard
        defaults.set(String(loc.latitude), forKey: Constants.KEY_LATITUDE)
        defaults.set(String(loc.longitude), forKey: Constants.KEY_LONGITUDE)
    }
    static func getUserLocationFromPrefs() -> CLLocationCoordinate2D{
        let defaults = UserDefaults.standard
        var location = CLLocationCoordinate2D()
        if let latVal = defaults.value(forKey: Constants.KEY_LATITUDE) {
            location.latitude = Double(latVal as! String)!
        }
        else{
            location.latitude = 0.0
        }
        if let longVal = defaults.value(forKey: Constants.KEY_LONGITUDE){
            location.longitude = Double(longVal as! String)!
        }
        else{
            location.longitude = 0.0
        }
        //location.latitude = 31.5546
        //location.longitude = 74.3572
        return location
    }
    
    static func isUserLoggedin() -> Bool{
        let userId  = getLoggedInUserId()
        if(userId.characters.count <= 0){
            return false
        }
            return true
    }
    static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        
        image.draw(in: CGRect(x:0.0, y:0.0, width:newSize.width, height:newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    static func getMonthNameForNumber(num: Int)->String{
        switch(num){
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return""
            
        }
        
    }
}
