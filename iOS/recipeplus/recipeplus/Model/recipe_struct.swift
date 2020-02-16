//
//  recipe_struct.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/16.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
// Codableの継承を忘れないこと！
struct Recipe: Codable {
    var status: String
    var responce : Responce
    
    struct Responce: Codable{
        var recipes: [Recipes]
        struct Recipes: Codable {
            var name: String
            var author: String
            var peaple: Int
            var comment: String
            var guidace: [Guidance]
            struct Guidance: Codable{
                var process: String
               // var thumbnail: String
            }
       //   var thumbnail: String
            var catchphrase: String
            var ingredients:[Ingredients]
            struct Ingredients: Codable{
                var name: String
                var amount: Double
                var fleshness: Double
                var item_class: String
            }
        }
    }
}
