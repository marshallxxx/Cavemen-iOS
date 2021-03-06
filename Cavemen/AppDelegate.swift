//
//  AppDelegate.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var coreDataManager:CoreDataManager = {
        return CoreDataManager()
    }()

    private var networkMng: NetworkManager?
    
    func initializeNetworkManager(endpoint: String) {
        networkMng = NetworkManager(endpoint: endpoint)
    }
    
    var networkManager: NetworkManager? {
        return networkMng
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if let options = launchOptions {
            if let notificaiton = options[UIApplicationLaunchOptionsRemoteNotificationKey] {
                print("%@", notificaiton)
            }
        }
  
        let types:UIUserNotificationType = ([.Alert, .Sound, .Badge])
        let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)

        if let endpoint = SettingsManager.getEndPoint() {
            initializeNetworkManager(endpoint)
        }

        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: Push Notification
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("%@", deviceToken)
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for var i = 0; i < deviceToken.length; i++ {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        SettingsManager.pushToken = tokenString
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications();
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("%@", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("%@", userInfo)
        
        let message = userInfo["aps"]?["alert"] as? String
        
        if let msg = message {
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            (window!.rootViewController! as! UINavigationController).topViewController?.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

}

