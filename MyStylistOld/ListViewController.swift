



import UIKit
import Photos

class ListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    //    @IBOutlet weak var imageView: UIImageView!
    
    let defaults = UserDefaults.standard
    
    // 取得したPHAssetを格納する配列
    var photoAssets: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                // 許可された場合のみ読み込み開始
                self.loadPhotos()
            case .denied: break
            // 拒否されている場合アラートを出すなり設定appへ誘導するなり
            default: break
                // このほかに restricted と determined が存在する
            }
        }
        
        //間の大きさ
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
    }
    
    
    func loadPhotos() {
        // 取得するものをimageに指定
        // 取得したい順番などあれば options に指定する
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        // PHAssetを一つ一つ格納
        assets.enumerateObjects { [weak self] (asset, index, stop) in
            self?.photoAssets.append(assets[index])
        }
    }
    
    //セルの個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    //セルを赤にする（作ってる途中に見やすくするため）
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    //セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
}
