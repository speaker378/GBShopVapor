//
//  DefaultResponse.swift
//  
//
//  Created by Сергей Черных on 31.05.2022.
//

import Vapor

struct DefaultResponse: Content {
    var result: UInt8
    var userMessage: String?
    var errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case userMessage = "user_message"
        case errorMessage = "error_message"
    }
}
