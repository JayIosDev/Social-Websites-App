//
//  AppDelegate.swift
//  GoogleSignInDemo
//
//  Created by Jayaram G on 07/01/19.
//  Copyright © 2019 Jayaram G. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate,GIDSignInDelegate {
    var loginVC:ViewController!
    var googleHomeVC:HomePageVC!
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error == nil{
            
            googleHomeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoogleHomeVC") as? HomePageVC
            
           googleHomeVC.incomingGoogleUser = user
            // present the HomeVC
            loginVC.present(googleHomeVC,animated: true ,completion: nil)
    
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    
    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyCzUTybhVinaq5L5q66Rgz4uzbZCIFdQfw")
        GMSPlacesClient.provideAPIKey("AIzaSyCzUTybhVinaq5L5q66Rgz4uzbZCIFdQfw")
        

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = "668607128221-9hiduosi7h1re0doal6622peml77kiol.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance()?.signInSilently()

        self.window  = UIWindow.init(frame: UIScreen.main.bounds)
        loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? ViewController
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
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

