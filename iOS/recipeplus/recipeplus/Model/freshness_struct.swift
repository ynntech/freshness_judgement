//
//  fleshness_struct.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/16.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
struct Freshness: Codable {
    var status: String
    var vegi_info: Info
    
    struct Info: Codable{
        var name:String
        var freshness:Double
    }
}
