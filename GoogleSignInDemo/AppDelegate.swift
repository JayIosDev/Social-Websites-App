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
class AppDelegate:UIResponder,UIApplicationDelegate,GIDSignInDelegate {
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
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      
    }

    func applicationWillTerminate(_ application: UIApplication) {
     
    }


}

