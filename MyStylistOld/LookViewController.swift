//
//  LookViewController.swift
//  Closet
//
//  Created by 繁野怜央 on 20200323.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import UIKit
import Photos

class LookViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    //メモ    (memo)
    @IBOutlet weak var textView: UITextView!
    //名前    (name)
    @IBOutlet weak var nametextField: UITextField!
    //色     (color)
    @IBOutlet weak var colortextField: UITextField!
    
    @IBOutlet weak var IdLabel: UILabel!
    
    var localId: String!
    
    //種類    (type)
    @IBOutlet weak var typetextField: UITextField! {
        
        didSet {
            nametextField.delegate = self
            colortextField.delegate = self
            typetextField.delegate = self
        }
    }
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Userdefaults Reed
        textView.text = defaults.string(forKey: "memo")
        nametextField.text = defaults.string(forKey: "name")
        colortextField.text = defaults.string(forKey: "color")
        typetextField.text = defaults.string(forKey: "type")
        
        IdLabel.text = defaults.string(forKey: "localId")
        
        localId = defaults.string(forKey: "localId")
        
        
        print(localId)
    }
    
    
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
