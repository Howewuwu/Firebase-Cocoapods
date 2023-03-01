//
//  FeedViewController.swift
//  Firebase & Cocoapods
//
//  Created by Howe on 2023/3/1.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func logoutPressed(_ sender: Any) {
        do { try Auth.auth().signOut()
            let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
            let delegate: SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
            // 上面這段不是用教學所說的因為 Appdelegate 功能有變所以換到 SceneDelegate 去，還未詳細了解
            
            // 另外不用 present 去切換畫面的原因老師是說會產生一個畫面的堆疊，加上目前是在 navigation 底下，會產生一個好像到了“下一個畫面”的感覺，然後也會產生一個會到上一個畫面的按鈕（navigation 會產生的），這裡是想要直接跳到登入那個畫面所以用這個方式來做
            
            delegate.window?.rootViewController = signInVC
        }
        catch let signOutError as NSError { print("Error signing out \(signOutError)") }
    }
    
}
