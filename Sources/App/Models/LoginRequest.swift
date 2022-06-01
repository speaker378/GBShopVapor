//
//  LoginRequest.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Vapor

struct LoginRequest: Content {
    let login: String
    let password: String
}
