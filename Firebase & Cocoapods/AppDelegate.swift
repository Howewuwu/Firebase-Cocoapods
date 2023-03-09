//
//  AppDelegate.swift
//  Firebase & Cocoapods
//
//  Created by Howe on 2023/2/13.
//

import UIKit
import FirebaseCore
// import FirebaseFirestoreSwift 這玩意兒沒了？
// import FirebaseFirestore  // Firebase 官網表示要寫入，而且 Packages 裡明明也有看到但現在卻找不到？？
import FirebaseAuth
import FirebaseRemoteConfig
import FirebaseFirestore
import FirebaseDatabase



@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
       
      
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        
        
        
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    
    
    
    
}

