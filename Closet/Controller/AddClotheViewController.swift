//
//  PlusclothViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/07/12.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import UIKit

class AddClotheViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var clotheColorTextField: UITextField!
    @IBOutlet var clotheThemeTextField: UITextField!
    @IBOutlet var clotheNameTextField: UITextField!
    @IBOutlet var clotheMemoTextView: UITextView!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var Button: UIButton!
    
    var colorTextFieldString = ""
    var themeTextFieldString = ""
    var nameTextFieldString = ""
    var memoTextViewString = ""
    var clotheImage: UIImage?
    let date = Date()
    let dateFormatter = DateFormatter()
    var nowDate = String()
    var imageName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clotheColorTextField.delegate = self
        clotheThemeTextField.delegate = self
        clotheNameTextField.delegate = self
        clotheMemoTextView.delegate = self
        clotheMemoTextView.layer.borderWidth = 1.0
        clotheMemoTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        navigationController?.presentationController?.delegate = self
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6823529412, green: 0.8549019608, blue: 1, alpha: 1)
        //            #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 1, alpha: 1)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //キーボード下げることについて
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
    
    
    //画面外をタッチしてキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clotheColorTextField.resignFirstResponder()
        clotheThemeTextField.resignFirstResponder()
        clotheNameTextField.resignFirstResponder()
        clotheMemoTextView.resignFirstResponder()
    }
    
    @IBAction func Alert(_ sender: UIButton){
        
        // UIAlertController
        let alertController: UIAlertController =
            UIAlertController(title: "Alert",
                              message: "選択してください",
                              preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "カメラ", style: .default){
            action in
            print("カメラボタンがタップされた")
            self.useCamera()
        }
        
        let actionAlbum = UIAlertAction(title: "アルバム", style: .default){
            action in
            print("アルバムボタンがタップされた")
            self.showAlbum()
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel){
            action in
            print("キャンセルボタンがタップされた")
        }
        
        // actionを追加
        alertController.addAction(actionCamera)
        alertController.addAction(actionAlbum)
        alertController.addAction(cancelAction)
        
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func useCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        // UIImagePickerController カメラを起動する
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //ここ
        let image = info[.originalImage] as! UIImage
        
        // 画像サイズ軽量化（40%カット）    参考：https://qiita.com/Tsh-43879562/items/4883c433bb7297019a1f
        let resizedImage = image.resized(withPercentage: 0.6)
        
        ImageView.image = image
        clotheImage = resizedImage
        self.dismiss(animated: true)
    }
    
    
    //保存が押されたとき
    @IBAction func saveClotheBtnWasPressed(_ sender: UIButton) {
        
        nameTextFieldString = clotheNameTextField.text!
        themeTextFieldString = clotheThemeTextField.text!
        colorTextFieldString = clotheColorTextField.text!
        memoTextViewString = clotheMemoTextView.text!
        
        //名前が入ってない場合アラートを表示する
        if clotheNameTextField.text == "" {
            
            let alertController = UIAlertController(title: "エラー",
                                                    message: "名前が未入力です",
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            
        }else if clotheImage == nil {
            
            let alertController = UIAlertController(title: "エラー",
                                                    message: "画像が未入力です",
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        }else{
            imageName = "Clothe-\(nowTime())"
            
            saveImageInDocumentDirectory(image: clotheImage!, fileName: imageName)
            
            guard let nameText = clotheNameTextField.text else {
                return
            }
            guard let themeText = clotheThemeTextField.text else {
                return
            }
            guard let colorText = clotheColorTextField.text else {
                return
            }
            guard let memoText = clotheMemoTextView.text else {
                return
            }
            
            saveClothe(clotheName: nameText, clotheFileName: imageName, clotheTheme: themeText, clotheColor: colorText, clotheMemo: memoText)
            
        }
        
        let tabVC = self.presentingViewController as! UITabBarController
        let navVC = tabVC.selectedViewController as! UINavigationController
        let vc = navVC.topViewController as! ClosetViewController
        vc.reload()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func saveImageInDocumentDirectory(image: UIImage, fileName: String){
        // pngとして保存
        let pndImageData = image.pngData()
        // DocumentディレクトリのfileURLを取得
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            try pndImageData!.write(to: fileURL)
            print("success")
        } catch {
            print("error")
            return
        }
    }
    
    func saveClothe(clotheName: String, clotheFileName: String, clotheTheme: String, clotheColor: String, clotheMemo: String){
        let clothe = Clothe(clotheColor: clotheColor, clotheName: clotheName, clotheFileName: clotheFileName, clotheTheme: clotheTheme, clotheMemo: clotheMemo)
        RealmService.shared.create(clothe)
    }
    
    func nowTime() -> String {
        // 日付をフォーマット
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd HH-mm-ss", options: 0, locale: Locale(identifier: "ja_jp"))
        
        // 日付をStringに変換
        nowDate = dateFormatter.string(from: date)
        
        // 「/」「 」「:」を全て「」に置き換える（削除）
        var replaceNowDate: String {
            let dictionary = ["/": "", " ": "", ":": ""]
            return dictionary.reduce(nowDate,  { $0.replacingOccurrences(of: $1.key, with: $1.value) })
        }
        print(replaceNowDate)
        return replaceNowDate
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        // true: スワイプで閉じる   false: スワイプで閉じない
        false
    }
}

extension UIImage {
    // データサイズを変更する（軽量化）
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

