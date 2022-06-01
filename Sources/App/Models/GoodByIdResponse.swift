//
//  GoodByIdResponse.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Vapor

struct GoodByIdResponse: Content {
    let result: Int
    let productName: String?
    let price: Double?
    let description: String?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case productName = "product_name"
        case price
        case description
        case errorMessage = "error_message"
    }
}
