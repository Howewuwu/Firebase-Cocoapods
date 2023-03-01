//
//  UploadViewController.swift
//  Firebase & Cocoapods
//
//  Created by Howe on 2023/3/1.

// 要使用相機或相簿時要使用者的同意，需在 info plist 新增兩條 Row 為 “Privacy - Camera Usage Description” ＆ “Privacy - Photo Library Usage Description”，並在旁邊簡單描述用途。

import UIKit
import FirebaseStorage
import FirebaseDatabase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let picker = UIImagePickerController()
    // 選擇照片或是拍下照片並使用的過程是使用 UIImagePickerController
    // UIImagePickerController 在使用時必須要有 delegate 才能去對應做選項
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
        view.addGestureRecognizer(tapGesture)
    // 增加手勢功能，（target：是指誰去做這件事,action：是指做什麼）
    // action 後面是用一個方式告訴它選某一個 method（另外寫）去做這件事
    
        
        
        
        
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        picker.dismiss(animated: true)
    }
    

    
    @objc func imagePressed(){
        
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imageView.image = image
            picker.dismiss(animated: true)
        }
        
    }
    
    
    
    

    @IBAction func share(_ sender: Any) {
    }
    
    
    
    @IBAction func takePic(_ sender: Any) {
    }
    
    
    

}
