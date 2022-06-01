//
//  GoodsListResponse.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Vapor

struct GoodsListResponse: Content {
    let result: Int
    let pageNumber: Int?
    let products: [GoodsListItem]?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case pageNumber = "page_number"
        case products
        case errorMessage = "error_message"
    }
}

struct GoodsListItem: Content {
    let productId: Int
    let productName: String
    let price: Double
    let productDescription: String
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productName = "product_name"
        case price
        case productDescription = "product_description"
    }
}
