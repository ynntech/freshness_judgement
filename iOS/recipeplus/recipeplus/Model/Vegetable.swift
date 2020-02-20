//
//  TodoItem.swift
//  recipeplus
//
//  Created by Yushi Nakaya on 2020/02/10.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//


import Foundation
import RealmSwift

// Todoアイテム
class Vegetable: Object {
    @objc dynamic var item_class :String = "vegetable"
    @objc dynamic var name :String = ""
    @objc dynamic var amount :Double = 0.0
    @objc dynamic var freshness : Double = 0.0
}
  
