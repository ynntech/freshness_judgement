//
//  ShowDetailViewController.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/20.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
import UIKit
class  ShowDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var recipe_name: UILabel!
    
    

    var guidance:[Recipe.Response.Recipes.Guidance]!
        var data:Recipe!
        var name:String = ""
        var processArray:[String] = []
        var count = 0
        override func viewDidLoad() {
                super.viewDidLoad()
            
            recipe_name.text = name
            for i in 0...guidance!.count-1{
                processArray.append("\(guidance[i].process!)")
            }
            
            print("processArray\(processArray)")
            
           
   
        
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableviewの関数1やで")
        return guidance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        print("guidance[indexPath.row].process は　\(String(describing: guidance[indexPath.row].process))")
        
        cell.textLabel!.text = processArray[indexPath.row]
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        cell.textLabel!.numberOfLines = 0
        return cell
    }
}

