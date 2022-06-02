//
//  PayCartRequest.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Vapor

struct PayCartRequest: Content {
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
