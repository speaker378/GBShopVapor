//
//  GetCartResponse.swift
//  
//
//  Created by Сергей Черных on 09.06.2022.
//

import Vapor

struct GetCartResponse: Content {
    let result: Int
    let products: [CartListItem]?
    let totalPrice: Double?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case products
        case totalPrice
        case errorMessage = "error_message"
    }
}

struct CartListItem: Content {
    let productId: Int
    let productName: String
    let price: Double
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productName = "product_name"
        case price
        case quantity
    }
}
