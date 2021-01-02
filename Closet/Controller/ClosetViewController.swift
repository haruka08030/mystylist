//
//  ClosetViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/06/28.
//  Copyright © 2020 杉山遥. All rights reserved.

import UIKit

class ClosetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!


    let realm = RealmService.shared.realm
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 1, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let results = realm.objects(Clothe.self)
        print(results)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        
    }
        
    //セルに写真を表示させる
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ClosetCollectionViewCell
        cell?.clotheImageView.image = loadImageFromDocumentDirectory(fileName: imageData)
        return cell
    }
    
    
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
    
    //セルの個数
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 90
       }
    
    //セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
}



