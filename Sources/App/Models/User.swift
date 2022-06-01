//
//  User.swift
//  
//
//  Created by Сергей Черных on 31.05.2022.
//

import Foundation
import Fluent
import Vapor

final class User: Model {
    
    static let schema = "users"
    
    @ID(custom: "id") var id: Int?
    @Field(key: "login") var login: String
    @OptionalField(key: "name") var name: String?
    @OptionalField(key: "last_name") var lastName: String?
    @Field(key: "password_hash") var passwordHash: String
    @Field(key: "email") var email: String
    @OptionalField(key: "gender") var gender: String?
    @OptionalField(key: "credit_card") var creditCard: String?
    @OptionalField(key: "bio") var bio: String?
    @OptionalField(key: "token") var token: String?
    
    init() { }
}

extension User: Content {
    convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? values.decode(Int.self, forKey: .id)
        self.login = try values.decode(String.self, forKey: .login)
        self.name = try? values.decode(String.self, forKey: .name)
        self.creditCard = try? values.decode(String.self, forKey: .creditCard)
        self.lastName = try? values.decode(String.self, forKey: .lastName)
        self.passwordHash = try values.decode(String.self, forKey: .password)
        self.email = try values.decode(String.self, forKey: .email)
        self.gender = try? values.decode(String.self, forKey: .gender)
        self.bio = try? values.decode(String.self, forKey: .bio)
        makeMD5Password()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case lastName = "last_name"
        case password
        case email
        case gender
        case creditCard = "credit_card"
        case bio
    }
    
    private func MD5(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    private func makeMD5Password() {
        self.passwordHash = MD5(self.passwordHash)
    }
}
