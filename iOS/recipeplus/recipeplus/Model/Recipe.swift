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
    var status: String?
    var response : Response?
    
    private enum Recipe: String,CodingKey{
       case status
       case response
    }
    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: Recipe.self)
       status = try values.decode(String.self,forKey:.status)
       response = try values.decode(Response.self,forKey:.response)
    }
    func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: Recipe.self)
       try container.encode(status, forKey: .status)
       try container.encode(response, forKey: .response)
    }
    
    
    struct Response: Codable{
        var recipes: [Recipes]?

        private enum Response: String,CodingKey{
           case recipes
        }
        init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: Response.self)
           recipes = try values.decode([Recipes].self,forKey:.recipes)
        }
        func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: Response.self)
           try container.encode(recipes, forKey: .recipes)
        }
        
        struct Recipes: Codable {
            var name: String?
            var author: String?
            var people: Int?
            var comment: String?
            var guidance: [Guidance]?
       //   var thumbnail: String
            var catchphrase: String?
            var ingredients:[Ingredients]?
            
            private enum Recipes: String,CodingKey{
                case name
                case author
                case people
                case comment
                case guidance
                case catchphrase
                case ingredients
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: Recipes.self)
                name = try values.decode(String.self,forKey:.name)
                author = try values.decode(String.self,forKey:.author)
                people = try values.decode(Int.self,forKey:.people)
                comment = try values.decode(String.self,forKey:.comment)
                guidance = try values.decode([Guidance].self, forKey: .guidance)
                catchphrase = try values.decode(String.self,forKey:.catchphrase)
                ingredients = try values.decode([Ingredients].self, forKey: .ingredients)
            }
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: Recipes.self)
                try container.encode(name, forKey: .name)
                try container.encode(author, forKey: .author)
                try container.encode(people, forKey: .people)
                try container.encode(comment, forKey: .comment)
                try container.encode(guidance, forKey: .guidance)
                try container.encode(catchphrase, forKey: .catchphrase)
                try container.encode(ingredients, forKey: .ingredients)
            }
            
            struct Guidance: Codable{
                var process: String?
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
            
            struct Ingredients: Codable{
                var name: String?
                var amount:String?
                var freshness: Double?
                var item_class: String?
                
                private enum Ingredients: String,CodingKey{
                    case name
                    case amount
                    case freshness
                    case item_class
                }
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: Ingredients.self)
                    name = try values.decode(String.self,forKey:.name)
                    amount = try values.decode(String.self,forKey:.amount)
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
            
            
        }
    }
}




