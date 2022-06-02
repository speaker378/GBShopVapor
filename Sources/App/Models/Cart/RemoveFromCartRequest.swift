//
//  RemoveFromCartRequest.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Vapor

struct RemoveFromCartRequest: Content {
    let productId: Int
    let userId: Int
    let quantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case userId = "user_id"
        case quantity
    }
}
