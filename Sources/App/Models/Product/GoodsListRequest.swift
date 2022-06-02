//
//  GoodsListRequest.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Vapor

struct GoodsListRequest: Content {
    let pageNumber: Int
    let categoryId: Int
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_number"
        case categoryId = "category_id"
    }
}
