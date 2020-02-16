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
        
        private enum Responce: String,CodingKey{
                           case recipes
                       }
                       init(from decoder: Decoder) throws {
                           let values = try decoder.container(keyedBy: Responce.self)
                           recipes = try values.decode([Recipes].self,forKey:.recipes)
                       }
                       func encode(to encoder: Encoder) throws {
                           var container = encoder.container(keyedBy: Responce.self)
                           try container.encode(recipes, forKey: .recipes)
                       }
        
        struct Recipes: Codable {
            var name: String
            var author: String
            var people: Int
            var comment: String
            var guidace: [Guidance]
       //   var thumbnail: String
            var catchphrase: String
            var ingredients:[Ingredients]
            
            private enum Recipes: String,CodingKey{
                case name
                case author
                case people
                case comment
                case guidace
                case catchphrase
                case ingredients
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: Recipes.self)
                name = try values.decode(String.self,forKey:.name)
                author = try values.decode(String.self,forKey:.author)
                people = try values.decode(Int.self,forKey:.people)
                comment = try values.decode(String.self,forKey:.comment)
                guidace = try values.decodeIfPresent([Guidance].self, forKey: .guidace)!
                catchphrase = try values.decode(String.self,forKey:.catchphrase)
                ingredients = try values.decodeIfPresent([Ingredients].self, forKey: .ingredients)!
            }
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: Recipes.self)
                try container.encode(name, forKey: .name)
                try container.encode(author, forKey: .author)
                try container.encode(people, forKey: .people)
                try container.encode(comment, forKey: .comment)
                try container.encode(guidace, forKey: .guidace)
                try container.encode(catchphrase, forKey: .catchphrase)
                try container.encode(ingredients, forKey: .ingredients)
            }
            
            
            
            struct Ingredients: Codable{
                var name: String
                var amount: Double
                var freshness: Double
                var item_class: String
                
                private enum Ingredients: String,CodingKey{
                    case name
                    case amount
                    case freshness
                    case item_class
                }
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: Ingredients.self)
                    name = try values.decode(String.self,forKey:.name)
                    amount = try values.decode(Double.self,forKey:.amount)
                    freshness = try values.decode(Double.self,forKey:.freshness)
                    item_class = try values.decode(String.self,forKey:.item_class)
                }
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: Ingredients.self)
                    try container.encode(name, forKey: .name)
                    try container.encode(amount, forKey: .amount)
                    try container.encode(freshness, forKey: .freshness)
                    try container.encode(item_class, forKey: .item_class)
                }
            }
            
            struct Guidance: Codable{
                var process: String
               // var thumbnail: String
                private enum Guidance: String,CodingKey{
                       case process
                   }
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: Guidance.self)
                    process = try values.decode(String.self,forKey:.process)
                }
                func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: Guidance.self)
                    try container.encode(process, forKey: .process)
                }
            }
        }
    }
}




