//
//  FirstViewController.swift
//  recipeplus
//
//  Created by Yushi Nakaya on 2020/02/07.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

// TODO: クライアント側で鮮度フィルターかけて必要そうなやつを整形してサーバーに投げる

import UIKit
import RealmSwift
import Foundation

//冷蔵庫情報送信&レシピ表示
class FirstViewController: UIViewController {
    @IBAction func reset_button(_ sender: Any) {
                var config = Realm.Configuration()
                config.deleteRealmIfMigrationNeeded = true
                let realm = try! Realm(configuration: config)
                try! realm.write {
                    realm.deleteAll()
                    print("データを削除しました")
                }
        for item in realm.objects(Vegetable.self).filter("item_class == %@","vegetable"){
              print("item.amount: \(item.name)")

          }
    }
    
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var textbox: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //recipeのpost
        

       

        
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm(configuration: config)
//        try! realm.write {
//            realm.deleteAll()
//        }
         for item in realm.objects(Vegetable.self).filter("item_class == %@","vegetable"){
             print("item.amount: \(item.amount)")
             print("item.name: \(item.name)")
         }
        
        //Realmオブジェクト生成
       

        
    }
    
    func textFieldDidChange(textFiled: UITextField) {
        name_label.text = textbox.text
    }
    @IBAction func button(_ sender: Any) {
        //textFieldDidChange(textFiled: textbox)
        let realm = try! Realm()
        for item in realm.objects(Vegetable.self).filter("name == %@",textbox.text ?? "aaa"){
            name_label.text = String(item.amount)
        }
    }

}

