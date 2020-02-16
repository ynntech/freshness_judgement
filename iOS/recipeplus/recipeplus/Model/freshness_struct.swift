//
//  fleshness_struct.swift
//  recipeplus
//
//  Created by 中屋悠資 on 2020/02/16.
//  Copyright © 2020 Yushi Nakaya. All rights reserved.
//

import Foundation
struct Freshness:Codable{
    var status:String
    var name:String?
    var freshness:Double?
    
    private enum CodingKeys: String,CodingKey{
        case status
        case vegi_info
    }
    private enum vegi_infoKeys: String,CodingKey{
        case name
        case freshness
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self,forKey:.status)
        
        let vegi_info = try values.nestedContainer(keyedBy: vegi_infoKeys.self, forKey: .vegi_info)
        name = try vegi_info.decode(String.self, forKey: .name)
        freshness = try vegi_info.decode(Double.self, forKey: .freshness)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)

        var vegi_info = container.nestedContainer(keyedBy: vegi_infoKeys.self, forKey: .vegi_info)
        try vegi_info.encode(name, forKey: .name)
        try vegi_info.encode(freshness, forKey: .freshness)
    }
}

