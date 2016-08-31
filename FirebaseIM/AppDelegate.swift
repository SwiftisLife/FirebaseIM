//
//  AppDelegate.swift
//  FirebaseIM
//
//  Created by Safina Lifa on 8/29/16.
//  Copyright © 2016 Safina Lifa. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
  
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Continue to play users music from iTunes/Apple Music/third party music streaming services
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        let uns: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(uns)
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        if let token = FIRInstanceID.instanceID().token() {
            sendTokenToServer(token)
            print("token is < \(token) >:")
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        
        
        print("didRegisterForRemoteNotificationsWithDeviceToken()")
        
        // if FirebaseAppDelegateProxyEnabled === NO:
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .Sandbox)
        
        print("APNS: <\(deviceToken)>")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError){
        
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
        
        
        print("didReceiveRemoteNotification()")
        
        //if FirebaseAppDelegateProxyEnabled === NO:
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        
        // handler(.NoData)
        
    }
    
    // [START refresh_token]
    func tokenRefreshNotification(notification: NSNotification) {
        print("tokenRefreshNotification()")
        if let token = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(token)")
            sendTokenToServer(token)
            FIRMessaging.messaging().subscribeToTopic("/topics/global")
            print("Subscribed to: /topics/global")
        }
        connectToFcm()
    }
    // [END refresh_token]
    
    func sendTokenToServer(currentToken: String) {
        print("sendTokenToServer() Token: \(currentToken)")
        // Send token to server ONLY IF NECESSARY
    }
    
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error!)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName ("continueVideo", object:nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       
        // UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        connectToFcm()
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    
    }
}