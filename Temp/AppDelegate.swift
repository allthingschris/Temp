//
//  AppDelegate.swift
//  Temp
//
//  Created by Christopher Ryan on 10/29/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    public var locationManager: CLLocationManager! = CLLocationManager()
    
    //Global Colors
    public let blueColor = UIColor.init(red: 0, green: 113/255, blue: 187/255, alpha: 1)
    public let cyanColor = UIColor.init(red: 37/255, green: 171/255, blue: 225/255, alpha: 1)
    public let greenColor = UIColor.init(red: 51/255, green: 181/255, blue: 75/255, alpha: 1)
    public let orangeColor = UIColor.init(red: 242/255, green: 91/255, blue: 38/255, alpha: 1)
    public let redColor = UIColor.init(red: 194/255, green: 41/255, blue: 46/255, alpha: 1)
    public let charcoalGradient = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.05)
    public let whiteGradient = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
    public var defaultColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    
    public var selectedDate: String = "yesterday"
    public var selectedTime: String = "morning"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    }
    
}
