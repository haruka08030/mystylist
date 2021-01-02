//
//  tamesuViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/01/07.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import UIKit

class tamesuViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    let list: [String] = ["メインクーン", "シャム", "ロシアンブルー", "アメリカンショートヘア", "ネベロング", "ビクシーボブ", "ラガマフィン", "ラパーマ"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.showsSelectionIndicator = true
            
            // 決定バーの生成
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
            let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            toolbar.setItems([spacelItem, doneItem], animated: true)
            
            // インプットビュー設定
            textField.inputView = pickerView
            textField.inputAccessoryView = toolbar
        }
    @objc func done() {
            textField.endEditing(true)
            textField.text = "\(list[pickerView.selectedRow(inComponent: 0)])"
        }
    }
     
    extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
     
        // ドラムロールの列数
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // ドラムロールの行数
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            /*
             列が複数ある場合は
             if component == 0 {
             } else {
             ...
             }
             こんな感じで分岐が可能
             */
            return list.count
        }
        
        // ドラムロールの各タイトル
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            /*
             列が複数ある場合は
             if component == 0 {
             } else {
             ...
             }
             こんな感じで分岐が可能
             */
            return list[row]
        }
       }
    

    
}
