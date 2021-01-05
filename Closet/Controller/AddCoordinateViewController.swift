//
//  PluscoordinateViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/07/12.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import UIKit

class AddCoordinateViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet var memotextView2: UITextView!
    @IBOutlet var systemtextField2: UITextField!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var image5: UIImageView!
    @IBOutlet var image6: UIImageView!
    @IBOutlet var image7: UIImageView!
    @IBOutlet var image8: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemtextField2.delegate = self
        memotextView2.delegate = self
        
        //選択した写真の枠線
        //pod "IBAnimatiible"を使用すれば省略化
        self.image1.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image1.layer.borderWidth = 1.0
        self.image2.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image2.layer.borderWidth = 1.0
        self.image3.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image3.layer.borderWidth = 1.0
        self.image4.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image4.layer.borderWidth = 1.0
        self.image5.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image5.layer.borderWidth = 1.0
        self.image6.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image6.layer.borderWidth = 1.0
        self.image7.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image7.layer.borderWidth = 1.0
        self.image8.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.image8.layer.borderWidth = 1.0
        
        memotextView2.layer.borderWidth = 1.0
        memotextView2.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
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
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    // キーボードが表示時に画面をずらす
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
        systemtextField2.resignFirstResponder()
        memotextView2.resignFirstResponder()
        
    }
    
}
