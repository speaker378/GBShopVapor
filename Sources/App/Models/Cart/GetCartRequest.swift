//
//  GetCartRequest.swift
//  
//
//  Created by Сергей Черных on 09.06.2022.
//

import Vapor

struct GetCartRequest: Content {
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

