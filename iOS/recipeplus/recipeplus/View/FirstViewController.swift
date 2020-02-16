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

struct Test:Codable{
    var status:String
    var people :Int
    private enum CodingKeys: String,CodingKey{
        case status
        case response
    }
    private enum ResponceKeys: String,CodingKey{
        case people
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self,forKey:.status)
        
        let responce = try values.nestedContainer(keyedBy: ResponceKeys.self, forKey: .response)
        people = try responce.decode(Int.self, forKey: .people)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)

        var responce = container.nestedContainer(keyedBy: ResponceKeys.self, forKey: .response)
        try responce.encode(people, forKey: .people)
    }
}

//冷蔵庫情報送信&レシピ表示
class FirstViewController: UIViewController {

    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var textbox: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //recipeのpost
        
//        let session_config: URLSessionConfiguration = URLSessionConfiguration.default
//        let recipe_session: URLSession = URLSession(configuration: session_config)
        let recipe_session = URLSession.shared
        let recipe_url: URL = URL(string: "http://3.13.39.141:8888/test/post")!
        var req: URLRequest = URLRequest(url: recipe_url)
        
        //通常のアクセストークンでひとまずは。
        
        let user_Token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3IiOiJnZW5lcmFsIn0.oT0j64dO3uZmN4_UMHFDIO4-Mvq7MDP-0Xe8a7ZYxR8"
        let admin_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3IiOiJhZG1pbiJ9.CZIK34BQgB_GmAwkx1dS9WUjUZTn_PQSY9HMQrKhG-A"
        
        //////////////////////////
        
        let name:String = "user"

        //////////////////////////
        
        let accessToken = (name == "admin") ? admin_token : user_Token
        req.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        req.httpMethod = "POST"
        
       
        let posttest = Vegetable()
        posttest.item_class = "vegetable"
        posttest.name = "にんじん"
        posttest.amount = 3.0
        posttest.freshness = 50.0
        /*
         本当に呼び出すときはこれでフィルタリングとか
         for item in realm.objects(Vegetable.self).filter("name == %@",textbox.text ?? "aaa"){
             name_label.text = String(item.amount)
         }
         */
        
        //書き換わるならvarかも
        let params:[String: Any] = [
          "ingredients":[
            [
              "item_class":posttest.item_class,
              "name":posttest.name,
              "amount":posttest.amount,
              "freshness":posttest.freshness
            ]
          ],
          "people":1,
          "show":1
        ]
        
        
        

        req.httpBody = try!JSONSerialization.data(withJSONObject: params)
        
        let post_task = recipe_session.dataTask(with: req, completionHandler: { (data, response, error) in
            
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                print("response.statusCode:\(response.statusCode)")
                let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                print("result is:\(result)")
                
                let newdata = """
                {
                    "status": "ok",
                    "response":
                    {
                        "people":1
                    }
                }
                """.data(using: .utf8)!
                
                let vegitest = try?JSONDecoder().decode(Test.self, from: newdata)
//                print(vegitest as Any)
//                print("status###: \(vegitest?.status)")
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let encoded = try! encoder.encode(vegitest?.people)
                print(String(data: encoded, encoding: .utf8)!)
            }
        })
        post_task.resume()
        
        
        
        
        
        
        
        
        //Realmオブジェクト生成
        
        let test = Vegetable()
        let test1 = Vegetable()
        
    
        test.item_class = "vegetable"
        test.name = "にんじん"
        test.amount = 3
        test.freshness = 0.0
        
        test1.item_class = "vegetable"
        test1.name = "aaa"
        test1.amount = 10
        test1.freshness = 0.0
        
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm(configuration: config)
        try! realm.write {
            realm.add(test)
            realm.add(test1)
        }
        
        
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

