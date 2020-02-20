//
//  ShowIngredientsViewController.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/20.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
import UIKit
class  ShowIngredientsViewController: UIViewController {
    var ingredients:[Recipe.Response.Recipes.Ingredients]!
        override func viewDidLoad() {
                print("showingligentsVCやで")
                super.viewDidLoad()
                
                print(ingredients![0].name!)
                print(ingredients![1].name!)
            }

    }
    
