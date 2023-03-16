//  FeedViewController.swift
//  Firebase & Cocoapods
//  Created by Howe on 2023/3/1.
//
// 目前在 main 中 Library 是選 Table View 不是 Table View Controller ~
// Table View 裡面增加 Prototype Cells ~ 就是 Table View cell
// Auto Layout 排設好的 Table View cell 就會是一個類似公版的存在，每有一個上傳就會使用這個 cell 當畫面產生
// 需給這個 cell 一個 identifier (因為會重複使用所以框框裡叫 Reuse Identifier)
// 因為這個 cell 上面有 ImageView, Label, textView, button 等等的，所以需要一個 class 去支援它去執行這件事
// Table View Cell Class 一樣用新增檔案用 Cocoa Touch Class，需注意 ➜ Subclass of: 要選 " UITableViewCell "
// 在把 main 上的 Table View Cell 指定 class 給剛生成的 TableViewCell Calss
// 最後把 @IBOutlet weak var userNameLabel: UILabel!, @IBOutlet weak var postImage: UIImageView!, @IBOutlet weak var postText: UITextView! 等等的指定好給剛生成的 TableViewCell Calss （在做指定時 UIImageView 原本想叫做 imageView，但系統說可能會產生錯誤所以換叫做 postImage）
// 其它像是 使用者大頭照或是一些 button 也是需要在 TableViewCell class 做指定～，基本上就是有做什麼功能在 cell，都是連到那個 TableViewCell class
// 但 Table View 是指定到這裡，感覺這之後會很容易忘記 XD


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
// 存放抓取而來的資料用
    
    var storage : StorageReference!
// 抓取資料用，跟 upload 一樣，需要有一個 reference 的位置才有辦法把值拿下來
// 但是這個好像沒有也沒差欸？
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        tableView.delegate = self
        tableView.dataSource = self
    // Ⓑ 一旦把 delegate & dataSource 指定為自己，自己的這個 class 它也必須是 delegate & dataSource 的這種形態（加繼承）
        
        
        getDataFromFirebase()
        
       
    }// viewDidLoad 的結尾在這
    

    
    
    
    func getDataFromFirebase(){
        let uid = Auth.auth().currentUser?.uid // 當作路徑來填下面的選項
        Database.database(url: "https://ch6-firebasecocoapods-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(uid!).child("posts").observe(.childAdded) { snapshot in
            // 上面是追本朔源上傳時的路徑已獲得需要抓取的資料
            // 若下一層資料夾是水平展開而不是向下延伸可以用 .observe(<#T##eventType: DataEventType##DataEventType#>, with: <#T##(DataSnapshot) -> Void#>) 這個方式來查看獲得
            // <#T##eventType: DataEventType##DataEventType#> ➡︎(.childAdded) ， <#T##(DataSnapshot) -> Void#> ➡︎ 按下 ↵ 會展開成 ➡︎ { <#DataSnapshot#> in <#code#> }      <#DataSnapshot#> ➡︎ snapshot （現在這一層所有資料的樣子的概念），  <#code#> ➡︎ 是個 clouse～ 接下來要做的事
            // 疑問："posts" 這一層下來之後其實是水平展開的數個資料夾（用 childByAutoId() 生成的)，每上傳一次就會產生一個資料夾裡面放上傳內容，不太懂為何 .observe 可以省略忽視這每一個資料夾？難道是跟 (.childAdded) 有關？
            // Database 相關的分層是用 “child()”，Storage 相關的分層是用 "/" 的樣子？
            
           // let value = snapshot.value as! NSDictionary
            let value = snapshot.value as! [String: Any]
            // 將拿下來的資料（在 snapshot.value 裡）轉換成 Dictionary，但就不知道為啥是 NSDictionary 而不是 Dictionary?
            // 後來問了 GPT 好像也是可以使用 Swift 的 Dictionary 格式來進行轉換，想說用 [Any: Any] 來表達結果不行 XD
            
            // 現在 value 被指定成為字典而 Firebase 後台的這一層水平線向外展的資料夾存取格式是 image : "https://firebasestorage.googleapis.com:443/v0/b/ch6-firebasecocoapods.appspot.com/o/uyGEJvpFuoh6ocDTlwFGO5sxnII2%2Fmedia%2F700213857807.jpg?alt=media&token=b4ef450f-4b31-4c99-94c0-793928dc63d0" 、 postTxt : "Test20" 、 postedBy : "ttest@wmigal"
            
            
            self.imageUrlArray.append(value["image"] as! String)
            
            
            self.emailArray.append(value["postedBy"] as! String)
            // 所就變成了 (value["postedBy"] as! String) → value 為此資料字典的變數，postedBy 為字典的 Key，這樣可拿到它的值為： ttest@wmigal ，再將它轉為字串 as! String，然後 append 到 emailArray 裡
            
            self.postTextArray.append(value["postText"] as! String)
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
        }
        // 這一大串註解是關於 DispatchQueue.main.async 因為畫面一開始產生時 TableViewDelegate 就已經去做畫面的佈局了，但是抓資料的時間會比本地端跑得慢所以這時不會有資料產生在畫面上
        // 因此在抓取完資料後需再次請它更新，請它 reloadData，這個事情我們會習慣把它放在 DispatchQueue
        // 老師說要把它放在 closure 裡面，當它執行完畢之後才會去執行這個 reloadData，必須要放在這個 database 的 snapshot 的 closure 底下
        // 如果放在外面，實際上就算你去執行這件事情因為裡面還沒執行完其時它也是來不及做執行的 ➡︎ 因為放在外面會同步執行吧（ 疑問：但 DispatchQueue 放的位置讓我很困惑，因為之前講串 API 時是說它不能放在裡面因為它是 closure 😨）
// 目前刷 AI 刷到比較有力的回答 ： 雖然將 tableView.reloadData() 方法放在閉包外部的最後一行也可以達到更新 UI 的效果，但是這種寫法可能會帶來一些問題。首先，Firebase 的數據加載是異步進行的，也就是說當 observe 方法被調用時，程式碼會立即繼續執行，而不會等待數據加載完成。因此，當 tableView.reloadData() 方法被調用時，並不能保證數據已經完全加載完成，這可能會導致 UI 上顯示的數據不完整或不正確。其次，如果在閉包外部調用 tableView.reloadData() 方法，這意味著每次加載新數據時，都會刷新整個 UITableView，這可能會對性能產生影響，尤其是當數據量較大時。相反，將 tableView.reloadData() 方法放在閉包內部的最後一行可以確保在新數據加載完成後再刷新 UITableView，這樣可以避免 UI 上顯示的數據不完整或不正確的問題。同時，只在必要時刷新 UITableView，可以最大程度地減少對性能的影響。因此，將 tableView.reloadData() 方法放在閉包內部是一種比較好的寫法。
// 🔥到這裡為止需要去 main 給 TableView 的 Row heigh & estimate 一個預設的高度跟尺寸不然會什麼都顯示不出來！🔥 
        }
        
       
        // 以上結束之後可以開始將資料放進 TableView 的 cell 裡面
        
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
    // 之後是以有幾筆資料來設定，比如 emailArray 有一筆那就 1 個 row 這樣，那目前上傳了 4 次就是 4 行這樣
// 疑問 ： 這個參數 section : Int 是指什麼？ (可能是指幾個 cell ?)
    
  
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) // 在 main 上指定的那個在 TableView 裡面 (Reuse Identifier) 的 cell，indexPath 則是跟著這個 func 在走，所以參數直接拿來使用，它就會分別顯示在哪個位置上面
        
        // ↓ 先用一個 optional binding，為什麼要用 optional binding 呢，因為現在的 cell 其實對它（dequeueReusableCell）來講，它是一個一般的 cell 而不是我們剛剛所寫的那個所謂的 Table View Cell，所以要先把它轉換一下
        // 但是我還是搞不懂，上面那一串不就已經指定了 "cell" 了嗎？ 還是是因為資料傳遞的時間差問題？
        if let postCell = cell as? TableViewCell{
        postCell.userNameLabel.text = emailArray[indexPath.row] // 將資訊指定給 TableViewCell 上的相關 Label，emailArray 的位置會根據 indexPath 做決定，它就會知道是哪個 row number，詳見Ⓖ
        postCell.postText.text = postTextArray[indexPath.row]
// indexPath 是 UITableView 的一個參數，用來描述表格視圖（UITableView）中某個儲存格（UITableViewCell）的位置，包含了其所在的 section 及 row。在 tableView(_:cellForRowAt:) 方法中，indexPath 用來取得特定位置的儲存格，從而進行相應的設定。

// Ⓖ 假設 ”ttest“ 的一筆資料（包含 image, postBy, postText）被抓了下來，會依照 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return emailArray.count }，開啟 1 個 section ( 依據重點在這段 "return emailArray.count" )，這一筆資料將會被佈在這 1 個 section 中，然後再依據 postCell.userNameLabel.text = emailArray[indexPath.row] 分別區分抓出對應的資料（重點在 emailArray[indexPath.row] 的 row ）
           
            let filePath = imageUrlArray[indexPath.row]
            AF.request(filePath).responseImage { response in
                
                if let image = response.value {
                    let size = CGSize(width: 414.0, height: 314.0)
                    let asepectScalerToFitImage = image.af.imageAspectScaled(toFit: size)
// AI 解釋：這段程式碼使用了 AlamofireImage 框架中的 AF.request(...).responseImage 方法來從 URL 加載圖片。該方法接受一個 URL 作為參數，當圖片加載完成時，會調用一個回調函數，該回調函數中的 response 參數包含了圖片加載的結果。如果 response.value 不為 nil，表示圖片加載成功，可以通過 response.value 屬性獲取加載的圖片。然後，使用 af.imageAspectScaled(toFit:) 方法將圖片按照指定大小進行縮放，並將縮放後的圖片設置為 postCell.postImage 的圖片。最後，使用 debugPrint 方法將 response 參數打印到控制台，以便調試和查看加載結果。總體來說，這段程式碼可以輕鬆地從 URL 加載圖片並將其設置為 UITableViewCell 中的圖片，同時可以避免 UI 线程被阻塞，增強了用戶體驗。
                    postCell.postImage.image = asepectScalerToFitImage
                }
                debugPrint(response)
            }
            
            return postCell // 以上資料若都有抓取成功的話會將 postCell 回傳，雖然我也不知道為何有時有些 optional binding 要回傳有些不用😨
        // 但經過測試 ⬆︎ 上面這個不回傳好像也沒關係欸？
        }
        return cell // 需 return 告訴它就是這個 cell
    }
// Ⓔ 告訴它每一個 cell 長什麼樣子，所以它 return 是一個 UITableViewCell ➞ 就會是我們在 main 上製作的那個 Cell
// 第一次看到 dequeueReusableCell
    
   
    
    
    

    
}


// “注意” ⬇︎
// 如果在 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return  } 、  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { <#code#> } 這兩個 method 放進來之後先 run 過的話會發現顯示的樣子怪怪的，那是因為 swift 會先以一些預設值參考然後呈現出來，所以看起來好像會跟在 main 上看到的不太一樣。
