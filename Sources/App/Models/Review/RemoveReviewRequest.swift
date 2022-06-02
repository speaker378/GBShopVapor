//
//  RemoveReviewRequest.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Vapor

struct RemoveReviewRequest: Content {
    let reviewId: Int
    
    enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
    }
}
