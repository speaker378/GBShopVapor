//
//  LoginResponse.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Vapor

struct LoginResponse: Content {
    let result: Int
    let user: UserData?
    let token: String?
    let errorMessage: String?
}

struct UserData: Content {
    let id: Int
    let login: String
    let name: String?
    let lastName: String?
    let email: String
    let gender: String?
    let creditCard: String?
    let bio: String?
}
