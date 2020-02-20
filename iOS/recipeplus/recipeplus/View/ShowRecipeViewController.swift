//
//  ShowRecipeViewContoroller.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/19.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
import UIKit
class  ShowRecipeViewController: UIViewController {
    
    let encoder = JSONEncoder()
    var data:Recipe?
    var number:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let label:String = String(data: try! encoder.encode(data?.response?.recipes?[number].name), encoding: .utf8)!
      //  titlelabel!.text = label

        
    }
}
