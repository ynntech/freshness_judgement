//
//  popupViewController.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/18.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class popupViewController: UIViewController {

    
    @IBAction func button(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        view.backgroundColor = color
    }
    
 
}
