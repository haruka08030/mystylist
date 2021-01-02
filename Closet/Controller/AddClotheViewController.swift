//
//  PlusclothViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/07/12.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import UIKit

class AddClotheViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clotheColorTextField.delegate = self
        clotheThemeTextField.delegate = self
        clotheNameTextField.delegate = self
        clotheMemoTextView.delegate = self
        clotheMemoTextView.layer.borderWidth = 1.0
        clotheMemoTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //ここ
        let image = info[.originalImage] as! UIImage
        ImageView.image = image
        clotheImage = image
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
            // 日付をフォーマット
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd HH-mm-ss", options: 0, locale: Locale(identifier: "ja_jp"))
            
            // 日付をStringに変換
            nowDate = dateFormatter.string(from: date)
            
            // 「/」「 」「:」を全て「-」に置き換える
            var replaceNowDate: String {
                let dictionary = ["/": "-", " ": "-", ":": "-"]
                return dictionary.reduce(nowDate,  { $0.replacingOccurrences(of: $1.key, with: $1.value) })
            }
            print(replaceNowDate)
            
            
            saveImageInDocumentDirectory(image: clotheImage!, fileName: "Clothe-\(replaceNowDate)")
            
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
            
            saveClothe(clotheName: nameText, clotheFileName: "Clothe-\(replaceNowDate)", clotheTheme: themeText, clotheColor: colorText, clotheMemo: memoText)
            
        }
        
        self.navigationController?.popViewController(animated: true)
        

    }

}

func saveImageInDocumentDirectory(image: UIImage, fileName: String){
    //DocumentディレクトリのfileURLを取得
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
    //
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    
    //UIImageをNSDataに変換
    if let imageData = image.pngData() {
        //画像データを一時ファイルとして保存
        try? imageData.write(to: fileURL, options: .atomic)
    }
}

func saveClothe(clotheName: String, clotheFileName: String, clotheTheme: String, clotheColor: String, clotheMemo: String){
    let clothe = Clothe(clotheColor: clotheColor, clotheName: clotheName, clotheFileName: clotheFileName, clotheTheme: clotheTheme, clotheMemo: clotheMemo)
    RealmService.shared.create(clothe)
    
}

