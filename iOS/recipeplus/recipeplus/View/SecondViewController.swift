//
//  SecondViewController.swift
//  recipeplus
//
//  Created by Yushi Nakaya on 2020/02/07.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import UIKit
import RealmSwift

struct judge_Struct: Codable {
    var item_class: String
    var fleshness: Double
}

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let base64String:String = "hogehoge"
        
        
        let judge_session = URLSession.shared
        let judge_url: URL = URL(string: "https://なんちゃらかんちゃら")!
        var req: URLRequest = URLRequest(url: judge_url)
        req.httpMethod = "POST"
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField:"ContentType")
        
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
                print(String(data: data, encoding: .utf8)!)
                print("response.statusCode:\(response.statusCode)")
                let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                print("result is:\(result)")
                }
             })
            post_task.resume()
        }
        
    }

