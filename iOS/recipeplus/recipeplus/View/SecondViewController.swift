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
    var peaple:String = "1"
    var recipe_data:Recipe!
    var number = 0
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
                 },
                {
                    "name":"人参と干しエビのかき揚げ",
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
                },
                {
                    "name":"鶏肉てりやきレタス巻",
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
    @IBOutlet weak var people_field: UITextField!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBAction func reload(_ sender: Any) {
              print("更新ボタン押されたよ")
              peaple = people_field.text ?? "1"
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
              "people":Int(peaple) ?? 1,
              "show":3
              ]
              print("params:\(params)")

              req.httpBody = try!JSONSerialization.data(withJSONObject: params)

              let post_task = recipe_session.dataTask(with: req, completionHandler: { (data, response, error) in
                
                if error == nil, let data = data, let response = response as? HTTPURLResponse {
                    print("response.statusCode:\(response.statusCode)")
                    let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                    print("result is:\(result)")
                    do{
                        //name, author,
                        
                        let recipe_data = try JSONDecoder().decode(Recipe.self, from: data)
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        let name1 = try! encoder.encode(recipe_data.response?.recipes?[0].name)
                      // responseがなかったときのコードをかく。
                        let name2 = try! encoder.encode(recipe_data.response?.recipes?[1].name)
                        let name3 = try! encoder.encode(recipe_data.response?.recipes?[2].name)
                        print(String(data: name1, encoding: .utf8)!)
                        print(String(data: name2, encoding: .utf8)!)
                        print(String(data: name3, encoding: .utf8)!)
                        
                        self.updata_label(data: recipe_data, name1: String(data: name1, encoding: .utf8)!, name2: String(data: name2, encoding: .utf8)!, name3: String(data: name3, encoding: .utf8)!)
                        
                        
                    }catch let tryerror as NSError{
                        print(tryerror.localizedDescription)
                    }
                    
                }
              })
              post_task.resume()
        
    }
    
    
    @IBAction func show1(_ sender: Any) {
        print("ぼたんおされたやで")
         number = 0
         performSegue(withIdentifier: "showrecipeSegue", sender: nil)

    }
  
   
    
    
    @IBAction func show2(_ sender: Any) {
        number = 1
        performSegue(withIdentifier: "showrecipeSegue", sender: nil)
    }
    
    @IBAction func show3(_ sender: Any) {
        number = 2
        performSegue(withIdentifier: "showrecipeSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("いまprepareやで")
             if segue.identifier == "showrecipeSegue" {
                 let nextVC = segue.destination as! ShowRecipeViewController
                print("recipe_data: \(String(describing: recipe_data))")
                print("recipe_data.status\(String(describing: recipe_data.status))")
                 nextVC.data = recipe_data
                nextVC.number = number
             }
    }
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
        "show":3
        ]
        print("params:\(params)")

        req.httpBody = try!JSONSerialization.data(withJSONObject: params)

        let post_task = recipe_session.dataTask(with: req, completionHandler: { (data, response, error) in
          
          if error == nil, let data = data, let response = response as? HTTPURLResponse {
              print("response.statusCode:\(response.statusCode)")
              let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
              print("result is:\(result)")
              do{
                    self.recipe_data = try JSONDecoder().decode(Recipe.self, from: data)
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let name1 = try! encoder.encode(self.recipe_data.response?.recipes?[0].name)
                    let name2 = try! encoder.encode(self.recipe_data.response?.recipes?[1].name)
                    let name3 = try! encoder.encode(self.recipe_data.response?.recipes?[2].name)
                    print(String(data: name1, encoding: .utf8)!)
                    print(String(data: name2, encoding: .utf8)!)
                    print(String(data: name3, encoding: .utf8)!)
                self.updata_label(data:self.recipe_data, name1: String(data: name1, encoding: .utf8)!, name2: String(data: name2, encoding: .utf8)!, name3: String(data: name3, encoding: .utf8)!)
              }catch let tryerror as NSError{
                  print(tryerror.localizedDescription)
              }
              
          }
        })
        post_task.resume()
        }
    
    
    func updata_label(data:Recipe,name1:String,name2:String,name3:String){
            //UI系の処理なのでメインスレッドで強制的に。
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.recipe_data = data
                    var name_1 = name1
                    var name_2 = name2
                    var name_3 = name3
                    //最初と最後の文字を消して""をはずしてる。
                    name_1 = String(name_1.suffix(name_1.count - 1))
                    name_1 = String(name_1[name_1.startIndex..<name_1.index(before: name_1
                        .endIndex)])
                    name_2 = String(name_2.suffix(name_2.count - 1))
                    name_2 = String(name_2[name_2.startIndex..<name_2.index(before: name_2.endIndex)])
                    name_3 = String(name_3.suffix(name_3.count - 1))
                    name_3 = String(name_3[name_3.startIndex..<name_3.index(before: name_3.endIndex)])
                    //ラベル更新
                    self.name1.text = name_1
                    self.name2.text = name_2
                    self.name3.text = name_3
                }
            }
        print("レシピ更新done")
        
    }
    
    }

