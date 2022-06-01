//
//  CreateUsers.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Fluent

extension User {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database
                .schema(User.schema)
                .field("id", .int)
                .field("login", .string)
                .field("name", .string)
                .field("last_name", .string)
                .field("password_hash", .string)
                .field("email", .string)
                .field("gender", .string)
                .field("credit_card", .string)
                .field("bio", .string)
                .field("token", .string)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(User.schema).delete()
        }
    }
}
