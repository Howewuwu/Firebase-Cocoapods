//
//  SignUpViewController.swift
//  Firebase & Cocoapods
//
//  Created by Howe on 2023/2/15.
//

import UIKit
import Firebase
import FirebaseAuth // 其實只要 import Firebase 它基本上都可以找到相關的其它 class，只是課程的老師說如果 code 有寫錯時它可能展時會找不到，這時就要再來 import 相關的 class.


class SignUpViewController: UIViewController {

    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var emailFiled: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipBtn.layer.cornerRadius = 8
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func createAccountPressed(_ sender: Any) {
        if let email = emailFiled.text, let password = passwordField.text,
           let confirmPasswd = confirmPasswordField.text {
            if password == confirmPasswd {
                Auth.auth().createUser(withEmail: email, password: password) { user, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("\(user!.user.email!) created")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
                    self.present(vc!, animated: true, completion: nil )
                }
            }else{
                print("Password didn't match")
            }
        }else{
            print("Field can't empty")
        }
    }
    
   

}
//test
