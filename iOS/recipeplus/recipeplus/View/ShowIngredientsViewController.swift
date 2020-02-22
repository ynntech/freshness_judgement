//
//  ShowIngredientsViewController.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/20.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
import UIKit
class  ShowIngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var name:String = ""
    var nameArray:[String] = []
    var count = 0
    var ingredients:[Recipe.Response.Recipes.Ingredients]!
    

    @IBOutlet weak var recipe_name: UILabel!


      override func viewDidLoad() {
              print("showingligentsVCやで")
              super.viewDidLoad()
              recipe_name.text = name
              for i in 0...ingredients!.count-1{
                  nameArray.append("\(ingredients[i].name!) : \(String(ingredients[i].amount!))")
              }
        
        print(nameArray)
          }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableviewの関数1やで")
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        print("ingredients[indexPath.row].name は　\(String(describing: ingredients[indexPath.row].name))")
        
        cell.textLabel!.text = nameArray[indexPath.row]
        return cell
    }
  }
    
