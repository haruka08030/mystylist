//
//  ClosetViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/06/28.
//  Copyright © 2020 杉山遥. All rights reserved.

import UIKit

class ClosetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let realm = RealmService.shared.realm
    
    var imageData = UIImage()
    
    var fileNameArray = [String]()
    
    var getImage = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.barTintColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 1, alpha: 1)
        
        collectionView.dataSource = self
        
        // collectionViewを動かしたらキーボードも閉じる
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        searchBar.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        
        // ---- realmからデータを取ってくる ----
        // ソート（降順）
        let results = realm.objects(Clothe.self).sorted(byKeyPath: "clotheFileName", ascending: false)
        // ソート（昇順）
//        let results = realm.objects(Clothe.self).sorted(byKeyPath: "clotheFileName", ascending: true)
        print(results)
        
        // データの数を取得　参考：https://www.paveway.info/entry/2019/01/13/swift_search
        let count = results.count
        if (count == 0) {
            // データが0個
            print("データなし")
        } else {
            // データが1個以上
            for results in results {
                fileNameArray.append(results.clotheFileName)
            }
        }
        // --------------------------------
        
    }
    
    // UISearchBarのキーボードを閉じる　参考：https://blog.masterka.net/archives/2109
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // 画面再表示（前の画面をdismissしたときに呼ばれる）
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
        collectionView.reloadData()
    }
    
    func reload() {
        print("reload")
        fileNameArray.removeAll()
        
        let results = realm.objects(Clothe.self).sorted(byKeyPath: "clotheFileName", ascending: false)
        
        // データの数を取得　参考：https://www.paveway.info/entry/2019/01/13/swift_search
        let count = results.count
        if (count == 0) {
            // データが0個
        } else {
            // データが1個以上
            for results in results {
                fileNameArray.append(results.clotheFileName)
            }
        }
    }
    
    //セルに写真を表示させる
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ClosetCollectionViewCell
        getImage = fileNameArray[indexPath.row]
        cell?.clotheImageView.image = loadImageFromDocumentDirectory(fileName: getImage)
        return cell!
    }
    
    // セルの個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileNameArray.count
    }
    
    // セルを選択
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(fileNameArray[indexPath.row])
        
        // 選択した写真から次の画面に遷移するコードをここに書く       ヒント：「画面遷移」「値渡し」
        <#code#>
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // 画像の取得
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsUrl.appendingPathComponent(getImage)
            if let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData){
                return image
            }
        }
        return nil
    }
    
    //セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
}
