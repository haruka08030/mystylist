//
//  ClosetViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/06/28.
//  Copyright © 2020 杉山遥. All rights reserved.

import UIKit
import RealmSwift
import SVProgressHUD

class ClosetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let realm = RealmService.shared.realm
    
    var imageData = UIImage()
    
    var fileNameArray = [String]()
    
    var searchResultsfileNameArray = [String]()
    
    var getImage = String()
    
    var searchController = UISearchController()
    
    var passDocName = String()
    
    var searchText = String()
    
    var clotheItems: Results<Clothe>?
    
    var searchResults = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // collectionViewを動かしたらキーボードも閉じる
        collectionView.keyboardDismissMode = .onDrag
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.collectionViewLayout = layout
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UISearchBarのキーボードを閉じる　参考：https://blog.masterka.net/archives/2109
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // 検索用
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // 画面再表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    private func setupNavBar() {
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6823529412, green: 0.8549019608, blue: 1, alpha: 1)
        // ナビゲーションバーのアイテムの色
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // UISearchControllerをUINavigationItemのsearchControllerプロパティにセット
        navigationItem.searchController = searchController
        
        // true：スクロールした時にSearchBarを隠す   false：スクロール位置に関係なく常にSearchBarが表示される
        navigationItem.hidesSearchBarWhenScrolling = true
        
        // タイトルを指定
        self.navigationItem.title = "全ての服"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.8549019608, blue: 1, alpha: 1)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
    }
    
    // 次の画面の画面を閉じたときに、再読み込みする
    func reload() {
        print("reload")
        SVProgressHUD.show()
        
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
        collectionView.reloadData()
        SVProgressHUD.dismiss()
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
        
        passDocName = fileNameArray[indexPath.row]
        
        // 選択した写真から次の画面に遷移するコード（値渡しを行う）
        performSegue(withIdentifier: "toLook", sender: nil)
        
        // コレクションビューの選択を解除する
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
        let horizontalSpace : CGFloat = 10
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt
                            indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        getImage = fileNameArray[indexPath.row]
        
        let previewProvider: () -> PreviewViewController? = { [unowned self] in
            return PreviewViewController(image: loadImageFromDocumentDirectory(fileName: getImage)!)
        }
        
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            
            let save = UIAction(title: "写真を保存", image: UIImage(systemName: "square.and.arrow.down"),
                                identifier: UIAction.Identifier(rawValue: "save")) { _ in
                // some action
                UIImageWriteToSavedPhotosAlbum(self.loadImageFromDocumentDirectory(fileName: self.getImage)!, self, nil, nil)
                print("save")
            }
            
            let share = UIAction(title: "共有", image: UIImage(systemName: "square.and.arrow.up"),
                                 identifier: UIAction.Identifier(rawValue: "share")) { _ in
                // some action
                print("shere")
            }
            
            // 今後追加可能
            
            //            let delete = UIAction(title: "削除", image: UIImage(systemName: "trash"), identifier: UIAction.Identifier(rawValue: "delete")) { _ in
            //                // some action
            //                let alert = UIAlertController(title: "削除しますか？", message: "削除すると元に戻せません。", preferredStyle: .alert)
            //                alert.addAction(UIAlertAction(title: "削除", style: .destructive) { _ in
            //
            //                    // アラート「削除」をタップした時の動作
            //                    let realm = try! Realm()
            //                    // 書き込みトランザクション開始
            //                    try! realm.write {
            //                        let results = realm.objects(Clothe.self).filter("clotheFileName == '\(self.getImage)'")
            //
            //                        realm.delete(results)
            //                        print("delete: success")
            //                    }
            //
            //                    collectionView.reloadData()
            //
            //                })
            //                alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            //                self.present(alert, animated: true)
            //
            //            }
            //            delete.attributes = [.destructive]
            
            return UIMenu(title: "", image: nil, identifier: nil, children: [save, share])
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: previewProvider,
                                          actionProvider: actionProvider)
    }
    
    override func prepare(for segue: UIStoryboardSegue,  sender: Any?) {
        if segue.identifier == "toLook" {
            let NavC = segue.destination as! UINavigationController
            let nextVC = NavC.topViewController as! LookViewController
            // 渡す値を指定する
            nextVC.fileId = passDocName
        }
    }
    
}

