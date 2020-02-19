//
//  SecondViewController.swift
//  recipeplus
//
//  Created by Yushi Nakaya on 2020/02/07.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import UIKit
import RealmSwift


class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recipe_session = URLSession.shared
        let recipe_url: URL = URL(string: "http://3.13.39.141:8888/request")!
        var req: URLRequest = URLRequest(url: recipe_url)

        //アクセストークン
        let user_Token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3IiOiJnZW5lcmFsIn0.oT0j64dO3uZmN4_UMHFDIO4-Mvq7MDP-0Xe8a7ZYxR8"
        let admin_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c3IiOiJhZG1pbiJ9.CZIK34BQgB_GmAwkx1dS9WUjUZTn_PQSY9HMQrKhG-A"



        let accessToken = user_Token
        req.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        req.httpMethod = "POST"
           
        
        
        let posttest = Vegetable()

        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm(configuration: config)
        //        try! realm.write {
        //            realm.deleteAll()
        //        }
     
        var vege_array:[String:Any] = [:]
        var recipe:[Any] = []

        for item in realm.objects(Vegetable.self).filter("item_class == %@","vegetable"){
            print("item.amount: \(item.amount)")
            print("item.name: \(item.name)")
            vege_array = ["item_class":item.item_class, "name":item.name, "amount":item.amount, "freshness":item.freshness]
            recipe.append(vege_array)

        }
        print("vege_array: \(vege_array)")

        //書き換わるならvarかも
        let params:[String: Any]
        
        
         params = [
        "ingredients":
          recipe
        ,
        "people":1,
        "show":1
        ]
        print("params:\(params)")

        req.httpBody = try!JSONSerialization.data(withJSONObject: params)

        let post_task = recipe_session.dataTask(with: req, completionHandler: { (data, response, error) in
          
          if error == nil, let data = data, let response = response as? HTTPURLResponse {
              print("response.statusCode:\(response.statusCode)")
              let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
              print("result is:\(result)")
              do{
  
                let jsondata = """
                    {
                        "status":"OK",
                        "response":
                        {
                        "recipes": [
                            {
                            "name":"じゃがいもとにんじんのきんぴら",
                            "author":"大庭英子",
                            "people":4,
                            "comment":"aa",
                            "guidance":[
                                {
                                "process":"じゃがいもは皮をむき、細切りにする。水にさっとさらしてアクを抜き、水けをきる。にんじんは皮をむき、長さ4cmの細切りにする。",
                                },
                                {
                                "process":"鍋にサラダ油大さじ1を中火で熱し、にんじん、じゃがいもを順に加えて炒める。全体に油が回ったらだし汁1/2カップを加え、煮立ったらAを加える。汁けがなくなるまで中火で炒めて器に盛り、白いりごまをふる。"
                                }
                                ],
                            "catchphrase":"じゃがいもとにんじんに甘辛てアクを抜き、水けをきる。にんじんは皮をむき、長さ4cmの細切りにする。",
                            "ingredients":[
                                {
                                "name":"じゃがいも",
                                "item_class":"vegetable",
                                "amount":"2",
                                "freshness":50
                                },
                                {
                                "name":"にんじん",
                                "item_class":"vegetable",
                                "amount":"1",
                                "freshness":50
                                },
                                {
                                "name":"白いりごま",
                                "item_class":"seasoning",
                                "amount":"4",
                                "freshness":100
                                },
                                {
                                "name":"みりん",
                                "item_class":"seasoning",
                                "amount":"4",
                                "freshness":100
                                },
                                {
                                "name":"醤油",
                                "item_class":"seasoning",
                                "amount":"4",
                                "freshness":100
                                },
                                {
                                "name":"サラダ油",
                                "item_class":"other",
                                "amount":"4",
                                "freshness":100
                                },
                                {
                                "name":"だし汁",
                                "item_class":"other",
                                "amount":"4",
                                "freshness":100
                                }
                            ]
                        }
                    ]
                }
            }
           """.data(using: .utf8)!
                  //name, author,
                  
                  let recipe_data = try JSONDecoder().decode(Recipe.self, from: data)
                  let encoder = JSONEncoder()
                  encoder.outputFormatting = .prettyPrinted
                  let encoded = try! encoder.encode(recipe_data.status)
                // responseがなかったときのコードをかく。
                  let encoded2 = try! encoder.encode(recipe_data.response?.recipes?[0].name)
                  print(String(data: encoded, encoding: .utf8)!)
                  print(String(data: encoded2, encoding: .utf8)!)
              }catch let tryerror as NSError{
                  print(tryerror.localizedDescription)
              }
              
          }
        })
        post_task.resume()
        }
    }

