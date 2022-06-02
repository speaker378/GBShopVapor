//
//  GetReviewsRequest.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Vapor

struct GetReviewsRequest: Content {
    let productId: Int
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
    }
}
