//
//  UploadViewController.swift
//  Firebase & Cocoapods
//
//  Created by Howe on 2023/3/1.

// 要使用相機或相簿時要使用者的同意，需在 info plist 新增兩條 Row 為 “Privacy - Camera Usage Description” ＆ “Privacy - Photo Library Usage Description”，並在旁邊簡單描述用途。

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let picker = UIImagePickerController()
    // 選擇照片或是拍下照片並使用的過程是使用 UIImagePickerController
    // UIImagePickerController 在使用時必須要有 delegate 才能去對應做選項
    
    var storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
    // delegate 主要的意思是說，當 picker 去做了什麼動作之後，這個動作可能是接在你的 picker 做完的某個動作後面，做完這個動作後面我們並不知道什麼時候執行，所以我們會交給 delegate 來做這件事情，也就是說 delegate 會去負責當你做完某件事情之後，它會去做剩下的動作，所以這個是在 iOS 的 framework 非常多的 objects 都會有這樣的性質，指定誰要來做這樣的動作，以這裡來講這個 picker.delegate 我們會把它寫在這個 UploadViewController 裡面，因此我們會去指定這個 picker.delegate 等於自己。
    
    // 因為我們指定了這個 delegate 等於自己（會發現它告訴我們說，它本身並不是一個跟 picker.delegate 相關的 object），所以要在 UploadViewController 的後面，就是它是誰的 subclass 後面我們還要加上其他的，包含了 UIImagePickerController 的 Delegate，記得這是一個 Delegate，那因為它需要的是一個畫面的轉換，所以還需要一個 UINavigationController 的 Delegate，需要去繼承這兩個 Delegate 的性質才能讓這個 picker.delegate 有作用。
        
    // 當然也可以另外開（寫）一個檔案，它是 ImagePickerControllerDelegate，不過我們這邊就簡單的把這個 delegate 交給它自己，就是 UploadViewController 裡面我們就直接讓它去做這樣的事情。
        
        
        statusLabel.text = "Tap pics to select from photo library"
        if let _ = imageView.image {
            
        } else { picker.sourceType = .photoLibrary }
        present(picker, animated: true, completion: nil)
        
        
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.imagePressed))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        // 增加手勢功能，（target：是指誰去做這件事,action：是指做什麼）
        // action 後面是用一個方式告訴它選某一個 method（另外寫）去做這件事，“#” 這個符號第一次看到
       
 
    
        
        
        
    } //這裡是 viewDidLoad 結尾
    
    
    // 前面需加 "@objc" 對應這個 “action: #selector(UploadViewController.imagePressed)”
    @objc func imagePressed() {
        
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    // 這個 func 執行完後依然會去執行 func imagePickerController 這串功能，因為它仍然還是一個 “picker”（let picker = UIImagePickerController()）的動作
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        picker.dismiss(animated: true)
    }
    // UIImagePickerControllerDelegate 裡面已經事先定義好 picker 做完之後可以做的事情，上面這串就是其中一個，：“當它去選擇了某個 media 之後，我們會去使用它”。
    // 一個物件的 delegate，比如說 “UIImagePickerControllerDelegate”，它裡面會去做 delegate 的 method 前面都會叫 “ImagePickerController”，後面再用不同的參數型態代表它做不同的事。

    

    @IBAction func share(_ sender: Any) {
        statusLabel.text = "開始上傳"
        if let image = imageView.image {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            
            let imagePath = Auth.auth().currentUser!.uid + "/media/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            // 設定檔案目錄的路徑，斜線 “ / ” 這個符號是增加目的地的意思（整個用 String 包住），再利用時間來標注照片的檔名（Date.timeIntervalSinceReferenceDate 本身會有小數點所以用 Int 包住），檔案的結尾是 .jpg
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            // 告知上傳檔案的格式與描述 （不是很懂）
            
            let storageRef = self.storage.reference(withPath: imagePath)
            // 告知路徑
            
            storageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    self.statusLabel.text = "上傳失敗"
                    print(error.localizedDescription)
                    return
                }
                self.statusLabel.text = "上傳成功"
            }
            // 上傳 + （上傳成功 or 上傳失敗）的處理
            
        }
    }
    // if let 與 guard let 的差別
    // if let 用於判斷一個可選值是否為 nil，並在不為 nil 的情況下進行後續處理；guard let 用於判斷一個可選值是否為 nil，如果是 nil 就提前退出當前作用域
    // 將 guard let 放入 if let 運用 if let 就可以不用是 if let XXX = XXX {.....} else {.....} 而是在 if let XXX = XXX {.....} 時就結束了？
    // UIImageJPEGRepresentation(UIImage, compressionQuality: ) 已更新成 ➜ UIImage.jpegData(compressionQuality: )
    
    
    @IBAction func takePic(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    // 上面這串是能夠讓手機相機拍完照之後取用的功能
    // 照完照選完照片之後一樣會去跑 func imagePickerController 這串功能
    // 『 疑問 』：" present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>) "，present 第一個參數要的型態是 UIViewController，可是 picker 能算是嗎？
    
    

}
