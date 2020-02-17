//
//  ThirdViewController.swift
//  recipeplus
//
//  Created by Yushi Nakaya on 2020/02/07.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//
import UIKit
import RealmSwift
import AVFoundation


class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBAction func startCamera(_ sender: UIBarButtonItem) {
        
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        //押されたら起動
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //プレビュー表示
        self.ImageView.image = image
        let data:NSData = image.pngData()! as NSData
        //toたかはっし　ここで、撮った写真imageをbase64にしてるやで
        let base64String = data.base64EncodedString(options: .lineLength64Characters)
        //よかったら保存
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        if image != nil{
            print("通信中")
            let judge_session = URLSession.shared
            let judge_url: URL = URL(string: "https://vegi-freshness.herokuapp.com/freshness")!
            var req: URLRequest = URLRequest(url: judge_url)
            req.httpMethod = "POST"
            //toたかはっし　ここがリクエストヘッダー
            req.addValue("application/json", forHTTPHeaderField: "Accept")
            req.addValue("application/json", forHTTPHeaderField:"ContentType")
            
            
            // Build our API request
            let jsonRequest : [String:Any] = [
                "file":base64String
            ]
            
            //toたかはっし　ここがリクエストbodyおくってるところやで
            req.httpBody = try! JSONSerialization.data(withJSONObject: jsonRequest, options: .prettyPrinted)
            let post_task = judge_session.dataTask(with: req, completionHandler: { (data, response, error) in
                 //let post_task = URLSession.shared.dataTask(with: req, completionHandler: { (data, response, error) in
                if error == nil, let data = data, let response = response as? HTTPURLResponse {
                         // do something
                    
                    //toたかはっし　これ以降は通信終わった後のレスポンスの処理のおはなしやで
                    let vegitest = try?JSONDecoder().decode(Freshness.self, from: data)
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let encoded = try! encoder.encode(vegitest)
                    print(String(data: encoded, encoding: .utf8)!)
                    
                    print("################")
                    print(String(data: data, encoding: .utf8)!)
                    print("response.statusCode:\(response.statusCode)")
                    let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                    print("result is:\(result)")
                    }
                 })
                post_task.resume()
        }
         
        
        self.dismiss(animated: true)
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


}
