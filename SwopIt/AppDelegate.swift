//
//  AppDelegate.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/12/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import Fabric
import Crashlytics
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI
import FirebaseInstanceID
//, FIRMessagingDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if(Utils.getCurrentDistancePreference() == nil ){
            Utils.setCurrentDistancePreference(val: 50.0)
        }
        
        SwopItLocationManager.getInstance().requestLocationUpdate()
        self.window?.rootViewController = MainTabsViewController()
        GMSServices.provideAPIKey("AIzaSyAi_Ps03oTgKwCcW_bTHDOWc82yQ6VGOHs")
        Fabric.with([Crashlytics.self])
        self.registerWithFriebaseForNotifications(application: application)
        
        return true

    }
    
    func registerWithFriebaseForNotifications(application: UIApplication){
        FIRApp.configure()

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("noti InstanceID token: \(refreshedToken)")
            Utils.setDeviceToken(val: refreshedToken)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X",    $1)})
        print("deviceToken: \(tokenString)")
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("noti InstanceID token: \(refreshedToken)")
            Utils.setDeviceToken(val: refreshedToken)
        }
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        print("noti refresh tocken")
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("noti InstanceID token: \(refreshedToken)")
            Utils.setDeviceToken(val: refreshedToken)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        getChatCount()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func getChatCount() {
        if(!Reachability.isConnectedToNetwork() && !Utils.isUserLoggedin()){
            return
        }
        let url = Constants.GET_NEW_MESSAGE_COUNT
        let params = [Constants.KEY_USER_ID :  Utils.getLoggedInUserId()]
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            if let respose = resp{
                let respCode = (respose[Constants.KEY_RESPONSE_CODE] as! Int)
                if(respCode == 1){
                    let a = respose["Response"] as! [String : AnyObject]
                    let count = a["Count"] as! Int
                    Utils.setNewMessageCount(val: count)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMenu"), object: nil)
                }
            }
        }
    }
    
    func showNotificationsAlert(type: String, senderUser: String, senderId: String){
        let alert = UIAlertController(title: "SwopIt", message: "You have a \(type)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if(type == "Chat"){
                let rootVC = self.window?.rootViewController as! MainTabsViewController
                rootVC.presentChatVCFromNotifications(userId: Utils.getLoggedInUserId(), userId2: senderId, receiver: senderUser)
            }
            else if(type == "Swap request"){
                let rootVC = self.window?.rootViewController as! MainTabsViewController
                rootVC.goToInboxFromNotifications()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        self.window?.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        if let type = userInfo["Type"], let recvr = userInfo["SenderUser"], let senderId = userInfo["SenderId"]{
            if(application.applicationState == .background){
                if(Utils.isUserLoggedin()){
                    if(type as! String == "Chat"){
                        let rootVC = self.window?.rootViewController as! MainTabsViewController
                        rootVC.presentChatVCFromNotifications(userId: Utils.getLoggedInUserId(), userId2: senderId as! String, receiver: recvr as! String)
                    }else if(type as! String == "Swap request"){
                        let rootVC = self.window?.rootViewController as! MainTabsViewController
                        rootVC.goToInboxFromNotifications()
                    }
                }
            }else{
                showNotificationsAlert(type: type as! String, senderUser: recvr as! String, senderId: senderId as! String)
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if let type = userInfo["Type"], let recvr = userInfo["SenderUser"], let senderId = userInfo["SenderId"]{
            if(application.applicationState == .background){
                if(Utils.isUserLoggedin()){
                    if(type as! String == "Chat"){
                        let rootVC = self.window?.rootViewController as! MainTabsViewController
                        rootVC.presentChatVCFromNotifications(userId: Utils.getLoggedInUserId(), userId2: senderId as! String, receiver: recvr as! String)
                    }else if(type as! String == "Swap request"){
                        let rootVC = self.window?.rootViewController as! MainTabsViewController
                        rootVC.goToInboxFromNotifications()
                    }
                }
            }else{
                showNotificationsAlert(type: type as! String, senderUser: recvr as! String, senderId: senderId as! String)
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func createNotification(title: String, type: String, senderName: String, senderId: String){
        
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = ""
            content.body = title
            content.categoryIdentifier = "alarm"
            content.userInfo = ["Type" : type, "senderName": senderName, "senderId":senderId, "aps":["alert":"Notfication", "sound":"default"]]
            content.sound = UNNotificationSound.default()
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            center.add(request)
            
        } else {
            let localNotification: UILocalNotification = UILocalNotification()
            localNotification.fireDate = NSDate().addingTimeInterval(-86400.0) as Date
            localNotification.alertBody = title
            localNotification.userInfo = ["Type" : type, "senderName": senderName, "senderId":senderId , "aps":["alert":"Notfication", "sound":"default"]]
            //        localNotification.applicationIconBadgeNumber = 1
            localNotification.timeZone = NSTimeZone.default
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
        
        
        
    }

    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

