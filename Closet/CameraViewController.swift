import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stertbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startCamera(){
        print("+ボタンが押されました")
        
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
                        
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    self.camera(sourceType: sourceType)

                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            print("許可されました")
                            DispatchQueue.main.async{
                                self.camera(sourceType: sourceType)
                            }
                        }else{
                            print("許可されませんでした")
                        }
                    }

                case .denied: // The user has previously denied access.
                    DispatchQueue.main.async{
                        
                    }
                    print(".denied")
                    return

                case .restricted: // The user can't grant access due to restrictions.
                    DispatchQueue.main.async{
                        
                    }
                    print(".restricted")
                    return
                default:
                    return
            }
            
        }else{
            print("エラー")
        }
    }
    
    func camera(sourceType:UIImagePickerController.SourceType){
        // インスタンスの作成
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
           
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 写真を保存
//    @IBAction func savePicture(_ sender : AnyObject) {
//        let image:UIImage! = imageView.image
//        
//        if image != nil {
//            UIImageWriteToSavedPhotosAlbum(
//                image,
//                self,
//                #selector(CameraViewController.image(_:didFinishSavingWithError:contextInfo:)),
//                nil)
//        }
//    }
    
    // 書き込み完了結果の受け取り
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            print(error.code)
           
    }
  

}
}
