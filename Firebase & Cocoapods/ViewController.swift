//
//  ViewController.swift
//  Firebase & Cocoapods
//
//  Created by Howe on 2023/2/13.
//

import UIKit
import Firebase
import FirebaseRemoteConfig



class ViewController: UIViewController {

    @IBOutlet weak var createBtn: UIButton!
   
    @IBOutlet weak var facebookLoginBtn: UIButton!
    @IBOutlet weak var googleLoginBtn: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
   
    //var remoteConfig : RemoteConfig!
    
    
    let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
    ]
    
    let facebookEnableKey = "FacebookLoginEnable"
    let googleEnableKey = "GoogleLoginEnable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attriString = NSMutableAttributedString(string: "Create an account", attributes: attributes)
        createBtn.setAttributedTitle(attriString, for: .normal)
        
        var remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.setDefaults(fromPlist: "RemoteConfig")
        
        remoteConfig.fetch { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            remoteConfig.activate { changed, error in
              // ...
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
          //self.displayWelcome()
         
            
            let enableFBLogin = remoteConfig[self.facebookEnableKey].boolValue
            let enableGoogleLogin = remoteConfig[self.googleEnableKey].boolValue
            self.facebookLoginBtn.isHidden = !enableFBLogin
            self.googleLoginBtn.isHidden = !enableGoogleLogin
           
        }

        
    }

    @IBAction func loginPressed(_ sender: Any) {
        Analytics.logEvent("loginEvent", parameters: nil)
        
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let error = error { print(error.localizedDescription)
                    return }
            }
            self.performSegue(withIdentifier: "login", sender: nil)
            
            }
        
    }
    
    
    

}

