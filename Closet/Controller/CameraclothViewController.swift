//
//  CameraclothViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/07/13.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import UIKit

class CameraclothViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var cameraView: UIImageView!
    
    var imageName = String()
    var clotheImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.image = getImageToDocumentDirectory(fileName: imageName)
        
        navigationController?.presentationController?.delegate = self
    }
    
    
    @IBAction func startcamera(_ sender: UIBarButtonItem) {
        useCamera()
    }
    
    @IBAction func showAlbum(_ sender : Any) {
       showAlbum()
    }
    
    @IBAction func decideTapped(_ sender: Any) {
        
        let preNC = self.presentingViewController as! UINavigationController
        // let preNC = self.navigationController as! UINavigationController でも可能かと思います
        let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! LookViewController
        preVC.passImage = self.cameraView.image!  //ここで値渡し
        
        let navVC = self.presentingViewController as! UINavigationController
        let vc = navVC.topViewController as! LookViewController
        vc.reload()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func caneclTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        cameraView.image = image
        clotheImage = resizedImage
        self.dismiss(animated: true)
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
            let fileURL = documentURL.appendingPathComponent(imageName)
            if let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            false
        }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "変更を破棄しますか？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "破棄", style: .destructive) { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
