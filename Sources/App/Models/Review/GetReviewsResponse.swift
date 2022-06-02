//
//  GetReviewsResponse.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Vapor

struct GetReviewsResponse: Content {
    let result: Int
    let reviews: [Review]?
    let errorMessage: String?
}
