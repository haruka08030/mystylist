//
//  Clothe.swift
//  Closet
//
//  Created by 杉山遥 on 2020/07/12.
//  Copyright © 2020 杉山遥. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Clothe: Object {
    
    dynamic var clotheID = UUID().uuidString
    dynamic var clotheName: String = ""
    dynamic var clotheColor: String = ""
    dynamic var clotheFileName: String = ""
    dynamic var clotheTheme: String = ""
    dynamic var clotheMemo: String = ""
    
    convenience init(clotheColor: String, clotheName: String, clotheFileName:   String,
                     clotheTheme: String, clotheMemo: String) {
        self.init()
        self.clotheName       = clotheName
        self.clotheColor      = clotheColor
        self.clotheTheme      = clotheTheme
        self.clotheFileName   = clotheFileName
        self.clotheMemo       = clotheMemo
    }
    
    override static func primaryKey() -> String? {
        return "clotheID"
    }
}
