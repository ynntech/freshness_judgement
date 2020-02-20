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
    
    @IBAction func detail_button(_ sender: Any) {
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    @IBAction func ingredients_button(_ sender: Any) {
        performSegue(withIdentifier: "showSegue", sender: nil)
    }
    var ingredients = [Recipe.Response.Recipes.Ingredients]()
    let encoder = JSONEncoder()
    var data:Recipe!
    var number:Int = 0
    override func viewDidLoad() {
        print("showrecipeVCやで")
        super.viewDidLoad()
        var label:String = (String(data: try! encoder.encode(data.response?.recipes?[number].name), encoding: .utf8) ?? nil)!
        print("label:\(label)")
        label = String(label.suffix(label.count - 1))
        label = String(label[label.startIndex..<label.index(before: label.endIndex)])
        titlelabel!.text = label
        ingredients = (data.response?.recipes?[number].ingredients)!
//        for i in data?.response?.recipes?[number].ingredients?.count{
//
//        }
        

        print(ingredients[0].name!)
        print(ingredients[1].name!)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         print("いまprepareやで")
              if segue.identifier == "showSegue" {
                  let nextVC = segue.destination as! ShowIngredientsViewController
                  nextVC.ingredients = ingredients
              }
     }
    
    
}
