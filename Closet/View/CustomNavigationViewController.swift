//
//  CustomNavigationViewController.swift
//  Closet
//
//  Created by 杉山遥 on 2020/06/28.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 1, alpha: 1)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    } 
}

