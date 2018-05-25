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
//, FIRMessagingDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if(Utils.getCurrentDistancePreference() == nil ){
            Utils.setCurrentDistancePreference(val: 50.0)
        }
        
        SwopItLocationManager.getInstance().requestLocationUpdate()
        self.window?.rootViewController = MainTabsViewController()
        GMSServices.provideAPIKey("AIzaSyDFJj0qTAOZqWM8PGDOcygn9rPuBbxbYjs")
        Fabric.with([Crashlytics.self])
        FIRApp.configure()
        self.registerWithFriebaseForNotifications(application: application)
        
        return true

    }
    
    func registerWithFriebaseForNotifications(application: UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        
        FIRMessaging.messaging().connect { error in
            if let err = error{
                print(err)
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("App Did Register : \(deviceToken)")

    }
    func tokenRefreshNotification(notification: NSNotification) {
        print("noti refresh tocken")
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("noti InstanceID token: \(refreshedToken)")
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void){
//        print("Here in UNUserNotifications")
//
//
//    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // Print message ID.
//        
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
//        
//        // Print full message.
//        print(userInfo)
//    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        
//        print("Message ID: \(userInfo)")
//
//        
//    }
//    
    
    func showNotificationsAlert(type: String, senderUser: String, senderId: String){
        let alert = UIAlertController(title: "SwopIt", message: "You have a \(type)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if(type == "Chat"){
                let rootVC = self.window?.rootViewController as! MainTabsViewController
                rootVC.presentChatVCFromNotifications(userId: Utils.getLoggedInUserId(), userId2: senderId, receiver: senderUser)
            }
            else{
                let rootVC = self.window?.rootViewController as! MainTabsViewController
                rootVC.goToInboxFromNotifications()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        self.window?.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
        let type = userInfo["Type"] as! String
        let recvr = userInfo["SenderUser"] as! String
        let senderId = userInfo["SenderId"] as! String
        if(application.applicationState == .background){
        
        if(Utils.isUserLoggedin()){
        if(type == "Chat"){
            let rootVC = self.window?.rootViewController as! MainTabsViewController
            rootVC.presentChatVCFromNotifications(userId: Utils.getLoggedInUserId(), userId2: senderId, receiver: recvr)
        }
        else{
            let rootVC = self.window?.rootViewController as! MainTabsViewController
            rootVC.goToInboxFromNotifications()
        }
        }
        }
        else{
            showNotificationsAlert(type: type, senderUser: recvr, senderId: senderId)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
        let type = userInfo["Type"] as! String
        let recvr = userInfo["SenderUser"] as! String
        let senderId = userInfo["SenderId"] as! String
        if(application.applicationState == .background){
       
        if(Utils.isUserLoggedin()){
            if(type == "Chat"){
                let rootVC = self.window?.rootViewController as! MainTabsViewController
                rootVC.presentChatVCFromNotifications(userId: Utils.getLoggedInUserId(), userId2: senderId, receiver: recvr)
            }
            else{
                let rootVC = self.window?.rootViewController as! MainTabsViewController
                rootVC.goToInboxFromNotifications()
            }
        }
        
        }
        else{
            showNotificationsAlert(type: type, senderUser: recvr, senderId: senderId)
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

    
    
//    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage){
//        print(remoteMessage.appData)
//        
//        let appDelegate =
//            UIApplication.shared.delegate as! AppDelegate
//       
//        print("Remote Message Done")
//    }
//  
}

