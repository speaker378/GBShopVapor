//
//  GoodByIdRequest.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Vapor

struct GoodByIdRequest: Content {
    let productId: Int
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
    }
}
