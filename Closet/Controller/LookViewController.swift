//
//  LookViewController.swift
//  Closet
//
//  Created by 繁野怜央 on 2021/01/09.
//  Copyright © 2021 杉山遥. All rights reserved.
//

import UIKit
import RealmSwift

class LookViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var clotheColorTextField: UITextField!
    @IBOutlet var clotheThemeTextField: UITextField!
    @IBOutlet var clotheNameTextField: UITextField!
    @IBOutlet var clotheMemoTextView: UITextView!
    @IBOutlet var ImageView: UIImageView!
    
    var fileId = String()
    
    var passImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let results = realm.objects(Clothe.self).filter("clotheFileName == '\(fileId)'")
        print(results)
        
        clotheNameTextField.text! = results[0].clotheName
        clotheColorTextField.text! = results[0].clotheColor
        clotheMemoTextView.text! = results[0].clotheMemo
        clotheThemeTextField.text! = results[0].clotheTheme
        
        ImageView.image = getImageToDocumentDirectory(fileName: fileId)
        
        navigationController?.presentationController?.delegate = self
        
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        let realm = try! Realm()
        // 書き込みトランザクション開始
        try! realm.write {
            let results = realm.objects(Clothe.self).filter("clotheFileName == '\(fileId)'")
            
            results[0].clotheName = clotheNameTextField.text!
            results[0].clotheColor = clotheColorTextField.text!
            results[0].clotheTheme = clotheThemeTextField.text!
            results[0].clotheMemo = clotheMemoTextView.text!
            
            print("update success!")
        }
        
        saveImageInDocumentDirectory(image: ImageView.image!, fileName: fileId)
        
        let tabVC = self.presentingViewController as! UITabBarController
        let navVC = tabVC.selectedViewController as! UINavigationController
        let vc = navVC.topViewController as! ClosetViewController
        vc.reload()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        let alert = UIAlertController(title: "変更を破棄しますか？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "破棄", style: .destructive) { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toCamera", sender: nil)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "削除しますか？", message: "削除すると元に戻せません。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "削除", style: .destructive) { _ in
            
            // アラート「削除」をタップした時の動作
            let realm = try! Realm()
            // 書き込みトランザクション開始
            try! realm.write {
                let results = realm.objects(Clothe.self).filter("clotheFileName == '\(self.fileId)'")
                
                realm.delete(results)
                print("delete: success")
            }
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func reload() {
        print("reload")
        ImageView.image = passImage
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
    
    // スワイプで閉じない場合に実行したい処理
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "変更を破棄しますか？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "破棄", style: .destructive) { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true)
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
    
    // 画像を取り出す
    func getImageToDocumentDirectory(fileName: String) -> UIImage? {
        if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentURL.appendingPathComponent(fileId)
            if let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue,  sender: Any?) {
        if segue.identifier == "toCamera" {
            let NavC = segue.destination as! UINavigationController
            let nextVC = NavC.topViewController as! CameraclothViewController
            // 渡す値を指定する
            nextVC.imageName = fileId
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
