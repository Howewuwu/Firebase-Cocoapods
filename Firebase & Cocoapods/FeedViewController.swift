//
//  FeedViewController.swift
//  Firebase & Cocoapods
//
//  Created by Howe on 2023/3/1.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

import Alamofire
import AlamofireImage


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
// Ⓒ 加了 UITableViewDelegate, UITableViewDataSource 後還是會有錯誤產生，是因為這個 FeedViewController 這個 class 它是 Table View 的 delegate，它也是 Table View 的 dataSource，在 iOS 的 framework 裡面如果是這兩個型態的 class 它就一定要去實作把某些 function 寫出來才不會產生錯誤，需加上 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return  } 、  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { <#code#> } ， 等等的寫在下面繼續看...
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
// Ⓐ Table View 其實是一個顯示資料的格式，但是它的資料本身其實是當它搜取到某些資料之後去做了顯示的畫面，比如說有幾個 cell，畫面上面分別會長什麼，其實是它收到資料才有辦法產生，所以我們並沒有辦法寫一個動作去告訴它在什麼時間做這件事，所以這樣的動作或者是說 Table View 這樣顯示的方式，它全部會交給 TableViewDelegate 這樣的方式來做設定，包含 Table View 的值要怎麼來，它有個叫做 Table View dataSource，那它的概念其實跟 Table View 的 delegate 很像，只是它們分別去做不一樣的動作，一個是畫面的動作產生，另外一個是跟資料相關的部分，你可以把它想成是一個幫忙 Table View 做這件事情的一個角色，因此我們會先去設定 Table View 它的 delegate 跟 dataSource 分別是誰...
    
    
    
    
    var emailArray = [String]()
    var imageUrlArray = [String]()
    var postTextArray = [String]()
// 存放本地資料用
    
    var storage : StorageReference!
// 拿資料用，跟 upload 一樣，需要有一個 reference 的位置才有辦法把值拿下來
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        tableView.delegate = self
        tableView.dataSource = self
    // Ⓑ 一旦把 delegate & dataSource 指定為自己，自己的這個 class 它也必須是 delegate & dataSource 的這種形態（加繼承）
        
        
        getDataFromFirebase()
        
       
    }// viewDidLoad 的結尾在這
    

    
    
    
    func getDataFromFirebase(){
        let uid = Auth.auth().currentUser?.uid
        Database.database(url: "https://ch6-firebasecocoapods-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(uid!).child("posts").observe(.childAdded) { snapshot in
            let value = snapshot.value as! NSDictionary
            self.imageUrlArray.append(value["image"] as! String)
            self.emailArray.append(value["postedBy"] as! String)
            self.postTextArray.append(value["postText"] as! String)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
        }
        
        
        }
        
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
    
  
    
    
    
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
// Ⓓ 這個 func 可以分成 section，而每個 section 裡面要產生幾個 row，這裡先預設產生 3 個 run 看看
    // 之後是以有幾筆資料來設定，比如 emailArray 有一筆那就 1 個 row 這樣
// 疑問 ： 這個參數 section : Int 是指什麼？ (可能是指幾個 cell ?)
    
  
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let postCell = cell as? TableViewCell{
            postCell.userNameLabel.text = emailArray[indexPath.row]
            postCell.postText.text = postTextArray[indexPath.row]
            
            let filePath = imageUrlArray[indexPath.row]
            AF.request(filePath).responseImage { response in
                
                if let image = response.value {
                    let size = CGSize(width: 414.0, height: 314.0)
                    let asepectScalerToFitImage = image.af.imageAspectScaled(toFit: size)
                    postCell.postImage.image = asepectScalerToFitImage
                }
                debugPrint(response)
            }
            
            return postCell
        }
        return cell
    }
// Ⓔ 告訴它每一個 cell 長什麼樣子，所以它 return 是一個 UITableViewCell
// 第一次看到 dequeueReusableCell
    
   
    
    
    
    
    
    
    
    
    
    
    
    
}
