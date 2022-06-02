//
//  AddReviewRequest.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Vapor

struct AddReviewRequest: Content {
    let productId: Int
    let userId: Int
    let text: String
    let rating: Int
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case userId = "user_id"
        case text
        case rating
    }
}
