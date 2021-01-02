

import UIKit
import AVFoundation
import AssetsLibrary
import Photos

//import PKHUD

class plusViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var plusButton: UIButton!
    
    //メモ    (memo)
    @IBOutlet weak var textView: UITextView!
    //名前    (name)
    @IBOutlet weak var nametextField: UITextField!
    //色     (color)
    @IBOutlet weak var colortextField: UITextField!
    //種類    (type)
    @IBOutlet weak var typetextField: UITextField!
    
    let defaults = UserDefaults.standard
    
    var saveArray: Array! = [NSData]()
    
    var image: UIImage!
    
    var localId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func sendSaveImage() {
            //NSData型にキャスト
            let data = image.pngData() as NSData?
            if let imageData = data {
                saveArray.append(imageData)
            }
        }
        
        
        nametextField.delegate = self
        colortextField.delegate = self
        typetextField.delegate = self
        
        //メモの枠線
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        
    }
    
    
    
    //Enterでキーボードを閉じるメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nametextField.resignFirstResponder()
        colortextField.resignFirstResponder()
        typetextField.resignFirstResponder()
        
        return true
    }
    
    //MARK: Userdefaultsの処理
    
    
    
    
    
    
    
    
    
    // MARK: 画像周辺の処理
    
    //画像の追加（撮影）
    @IBAction func plusButton(_ sender: UIButton) {
        
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("カメラは利用できます")
            
            // (1)UIImagePickerControllerのインスタンスを作成
            let imagePickerController = UIImagePickerController()
            // (2)sourceTypeにcameraを設定
            imagePickerController.sourceType = .camera
            // (3)delegate設置
            imagePickerController.delegate = self
            // (4)モーダルビューで表示
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラは利用できません")
        }
        
    }
    
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[.originalImage] as? UIImage {
            pictureImage.contentMode = .scaleAspectFit
            pictureImage.image = pickedImage
            
            PHPhotoLibrary.shared().performChanges({
                
                let request = PHAssetChangeRequest.creationRequestForAsset(from: pickedImage)
                self.localId = request.placeholderForCreatedAsset?.localIdentifier
                
            }, completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    if let localId = self.localId {
                        let results = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil)
                        if results.count > 0 {
                            let asset = results.firstObject
                        }
                    }
                }
            })
            
        }
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    //写真・文字を保存
    @IBAction func savePicture(_ sender : AnyObject) {
        
        //Userdefaults - Save
        defaults.set(nametextField.text!, forKey: "name")
        defaults.set(colortextField.text!, forKey: "color")
        defaults.set(typetextField.text!, forKey: "type")
        defaults.set(textView.text!, forKey: "memo")
        defaults.set(localId, forKey: "localId")

        defaults.set(saveArray, forKey: "image")
        defaults.synchronize()
        
        
        let image: UIImage! = pictureImage.image
        
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(
                image,
                self,
                #selector(plusViewController.image(_:didFinishSavingWithError:contextInfo:)),
                nil)
        }
        print("保存完了")
        print(localId)
        
        //        showで画面遷移の場合はこれを記載
        //        dismiss(animated: true, completion: nil)
        
        //        //保存が完了したことを知らせるためのHUD
        //        HUD.flash(.success)
        
    }
    
    // 書き込み完了結果の受け取り
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            print(error.code)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.pictureImage.image = image as? UIImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: その他オプション
    
    //キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //キーボード下げることについて
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Notification発行
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()
    }
    
    
    // Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
        print("Notificationを発行")
    }
    
    // キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
        print("keyboardWillShowを実行")
    }
    
    // キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
    }
    
}


extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
