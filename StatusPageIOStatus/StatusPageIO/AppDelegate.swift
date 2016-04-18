//
//  AppDelegate.swift
//  CloudFlareStatus
//
//  Created by Mathew Jenkinson on 09/03/2016.
//  Copyright © 2016 Mathew Jenkinson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, APIControllerProtocol {
    let api = APIController()
    
    var window: UIWindow?
    let StatusPageIOName: String = "" // The name of the StatusPageIO Page you are looking at. 
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Launched App when the user accepts our Push permission request.
        //print("Success, the device token is: \(deviceToken)")
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        //print("DeviceToken String is: \(deviceTokenStr)")
        // Make a API Request to our Blab Endpoint
        //print(UIDevice.currentDevice().modelName)
        let Device = UIDevice.currentDevice()
        //print(Device.systemVersion)
        
        // Because of the way Apple Push now works with random tokens we need to be smart about how we register devices on the API.
        // If we just keep adding tokens we will eventually have a lot of dead tokens.
        
        // The way to fix this is to store the APNS token in NSUserDefaults and then check if our new value is the same, if we have the same value we dont need to make a new API request.
        // If its a new value it means that something changed and we need to update both NSUserDefaults but also the API.
        if let APNSUserDefaultKey = NSUserDefaults.standardUserDefaults().objectForKey("APNSKey") {
            if APNSUserDefaultKey as! String != deviceTokenStr {
                print("APNS Key existed but it didnt match")
                api.registerforRemoteNotificationsWithNotificationServer("https://domain.com/RegisterNewDeviceKey.php", datatoPost: "Username=TwilioStatus@blabto.me&Password=Tw1l10StatusApp&DeviceTokenStr=\(deviceTokenStr)&DeviceType=\(UIDevice.currentDevice().modelName)&DeviceOS=\(Device.systemVersion)", loginString: "TwilioStatus@blabto.me:Tw1l10StatusApp")
                NSUserDefaults.standardUserDefaults().setObject(deviceTokenStr, forKey: "APNSKey")
            }
        }else{
            print("No APNS Key Existed, making API Request and adding key to the preferences")
            print("DeviceToken String is: \(deviceTokenStr)")
            api.registerforRemoteNotificationsWithNotificationServer("https://domain.com/TwilioStatusApp/RegisterNewDeviceKey.php", datatoPost: "Username=TwilioStatus@blabto.me&Password=Tw1l10StatusApp&DeviceTokenStr=\(deviceTokenStr)&DeviceType=\(UIDevice.currentDevice().modelName)&DeviceOS=\(Device.systemVersion)", loginString: "TwilioStatus@blabto.me:Tw1l10StatusApp")
            NSUserDefaults.standardUserDefaults().setObject(deviceTokenStr, forKey: "APNSKey")
        }
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Device token for push notifications: FAIL -- ")
        print(error.description)
    }
    
    func convertDeviceTokenToString(deviceToken:NSData) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "")
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "")
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercaseString
        return deviceTokenStr
    }
    
    func didReceiveAPIResults(results: AnyObject) {
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Got a \(StatusPageIOName) Status Update")
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        let mainStoryboardViewController : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleriOSDevice : UIViewController = mainStoryboardViewController.instantiateViewControllerWithIdentifier("StatusPageIOStatusIncidentsViewController") as UIViewController
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = initialViewControlleriOSDevice
        self.window?.makeKeyAndVisible()
    }
}