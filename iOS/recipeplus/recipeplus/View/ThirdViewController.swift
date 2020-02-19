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

//カメラのところ
class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    var alertController: UIAlertController!
    var vege_name:String = ""
    var vege_freshness:String = ""
    var status = 0
    var fresh_value:Double = 100
    @IBOutlet weak var amout_field: UITextField!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var vege_namelabel: UITextField!
    @IBOutlet weak var vege_freshnesslabel: UILabel!
    @IBOutlet weak var discriptionlabel: UILabel!
    @IBOutlet weak var amountlabel: UITextField!
    
    @IBAction func register_button(_ sender: Any) {
    
        //写真を取られた直後以外は登録できないようにする
        if status == 1{
            let alert: UIAlertController = UIAlertController(title: "登録しますか", message:  "", preferredStyle:  UIAlertController.Style.alert)
               // 確定ボタンの処理
               let confirmAction: UIAlertAction = UIAlertAction(title: "登録", style: UIAlertAction.Style.default, handler:{
                   // 確定ボタンが押された時の処理をクロージャ実装する
                   (action: UIAlertAction!) -> Void in
                   //実際の処理
                    print("登録")
                    
                    let vege = Vegetable()
                    vege.item_class = "vegetable"
                    vege.name = self.vege_namelabel.text ?? "-"
                    vege.freshness = self.fresh_value
                    vege.amount = Double(self.amout_field.text ?? "1")!
                    print("vege.name:\(vege.name)")



                    var config = Realm.Configuration()
                    config.deleteRealmIfMigrationNeeded = true
                    let realm = try! Realm(configuration: config)
                    try! realm.write {
                        realm.add(vege)
                    }
                    self.status = 0
                    self.alert(title: "登録しました",message: "今日も一日おつかれさまです！")
               })
               // キャンセルボタンの処理
               let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                   // キャンセルボタンが押された時の処理をクロージャ実装する
                   (action: UIAlertAction!) -> Void in
                   //実際の処理
                   print("キャンセル")
                   self.status = 0
               })
               //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
               alert.addAction(cancelAction)
               alert.addAction(confirmAction)

               //実際にAlertを表示する
               present(alert, animated: true, completion: nil)
            
        }
        status = 0
    }
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
    
    
   func alert(title:String, message:String) {
         alertController = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK",
                                        style: .default,
                                        handler: nil))
         present(alertController, animated: true)
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        status = 0
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //プレビュー表示
        self.ImageView.image = image
        let data:NSData = image.pngData()! as NSData
        //toたかはっし　ここで、撮った写真imageをbase64にしてるやで
        let base64String = data.base64EncodedString(options: .lineLength64Characters)
        //よかったら保存
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        judgement_label()
        if image != nil{
            print("通信中")
            let judge_session = URLSession.shared
            let judge_url: URL = URL(string: "https://vegi-freshness.herokuapp.com/freshness")!
            var req: URLRequest = URLRequest(url: judge_url)
            req.httpMethod = "POST"
            //toたかはっし　ここがリクエストヘッダー
            req.addValue("application/json", forHTTPHeaderField: "Accept")
            req.addValue("application/json", forHTTPHeaderField:"Content-Type")
            
            
            // Build our API request
            let jsonRequest : [String:Any] = [
                "file":base64String
            ]
            
            //toたかはっし　ここがリクエストbodyおくってるところやで
            req.httpBody = try! JSONSerialization.data(withJSONObject: jsonRequest, options: .prettyPrinted)
            // let jsonData =  try! JSONSerialization.data(withJSONObject: jsonRequest, options: .prettyPrinted)
           //  req.httpBody  = String(bytes: jsonData, encoding: .utf8)! とかにするとjsonの文字列として送れる。
            let post_task = judge_session.dataTask(with: req, completionHandler: { (data, response, error) in
                 //let post_task = URLSession.shared.dataTask(with: req, completionHandler: { (data, response, error) in

                if error == nil, let data = data, let response = response as? HTTPURLResponse {
                         // do something
                    
                    //toたかはっし　これ以降は通信終わった後のレスポンスの処理のおはなしやで
                    let vege = try?JSONDecoder().decode(Freshness.self, from: data)
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let encoded_name = try! encoder.encode(vege?.name)
                    let encoded_freshness = try! encoder.encode(vege?.freshness)
                    var name = String(data: encoded_name, encoding: .utf8)!
                    let freshness = String(data: encoded_freshness, encoding: .utf8)!
                    print(String(data: encoded_name, encoding: .utf8)!)
                    print(String(data: encoded_freshness, encoding: .utf8)!)
                    //self.vege_name = String(data: encoded_name,encoding: .utf8)!
                    //self.vege_freshness = String(data: encoded_freshness, encoding: .utf8)!
                    name = String(name.suffix(name.count - 1))
                    name = String(name[name.startIndex..<name.index(before: name.endIndex)])
                    self.update_label(name: name, freshness: freshness)
                    self.status = 0
                    }
                 })
                post_task.resume()
        }
         
        
        self.dismiss(animated: true)
        
    
    }
    
    func update_label(name:String, freshness:String){
        print("判定完了")
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.vege_namelabel.text = name
                self.amountlabel.text = "1"
                self.discriptionlabel.text = "-- タップで変更 --"
                var labeltext:String
                self.fresh_value = Double(freshness)!
                if self.fresh_value>=80{
                    labeltext = "新鮮です"
                }else if self.fresh_value>=40{
                    labeltext = "まだ食べれます"
                }else{
                    labeltext = "食べられません"
                }
                self.vege_freshnesslabel.text = labeltext
                self.status = 1

            }
        }
    }
    func judgement_label(){
        print("判定中")
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.vege_namelabel.text = "判定中"
                self.vege_freshnesslabel.text = "判定中"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewdidload")
        status = 0
        
        
    }



}
