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
        let base64String:String = "hogehoge"
        
        let judge_session = URLSession.shared
        let judge_url: URL = URL(string: "http://3.13.39.141:8888/")!
        var req: URLRequest = URLRequest(url: judge_url)
        req.httpMethod = "POST"
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField:"ContentType")
        print("aaaaa")
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": base64String
                ]
            ]
        ]
        

        req.httpBody = try! JSONSerialization.data(withJSONObject: jsonRequest, options: .prettyPrinted)
        let post_task = judge_session.dataTask(with: req, completionHandler: { (data, response, error) in
             //let post_task = URLSession.shared.dataTask(with: req, completionHandler: { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                     // do something
               // print(String(data: data, encoding: .utf8)!)
                //print("response.statusCode:\(response.statusCode)")
                let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
               // print("result is:\(result)")
                }
             })
            post_task.resume()
        
        
    print("aaaaaaaaaaaaaaaaa=======")
        
       let data = """
         {
             "status":"OK",
             "response":
             {
             "recipes": [
                 {
                 "name":"じゃがいもとにんじんのきんぴら",
                 "author":"大庭英子",
                 "people":4,
                 "comment":"",
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
                     "class":"vegetable",
                     "amount":2,"freshness":50

                     },
                     {
                     "name":"にんじん",
                     "class":"vegetable",
                     "amount":1,"freshness":50

                     },
                     {
                     "name":"白いりごま",
                     "class":"seasoning",
                     "amount":"少々",
                     "freshness":100

                     },
                     {
                     "name":"みりん",
                     "class":"seasoning",
                     "amount":"大さじ1",
                     "freshness":100

                     },
                     {
                     "name":"醤油",
                     "class":"seasoning",
                     "amount":"大さじ1",
                     "freshness":100

                     },
                     {
                     "name":"サラダ油",
                     "class":"other",
                     "amount":null,
                     "freshness":100

                     },
                     {
                     "name":"だし汁",
                     "class":"other",
                     "amount":null,
                     "freshness":100

                     }
                     }
                 ]
             }
         }
        """.data(using: .utf8)!
        
        let vegitest = try?JSONDecoder().decode(Recipe.self, from: data)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encoded = try! encoder.encode(vegitest)
        print(String(data: encoded, encoding: .utf8)!)
        }
    }

