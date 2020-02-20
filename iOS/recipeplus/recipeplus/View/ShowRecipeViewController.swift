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
    @IBOutlet weak var titlelabel: UILabel!
    
    
    let encoder = JSONEncoder()
    var data:Recipe?
    var number:Int = 0
    override func viewDidLoad() {
        print("showrecipeVCやで")
        super.viewDidLoad()
        var label:String = String(data: try! encoder.encode(data?.response?.recipes?[number].name), encoding: .utf8)!
        print("label:\(label)")
        label = String(label.suffix(label.count - 1))
        label = String(label[label.startIndex..<label.index(before: label.endIndex)])
        titlelabel!.text = label

        
    }
}
