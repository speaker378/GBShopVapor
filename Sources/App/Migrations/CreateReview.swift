//
//  CreateReview.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Fluent

extension Review {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database
                .schema(Review.schema)
                .field("id", .int)
                .field("product_id", .int)
                .field("user_id", .int)
                .field("text", .string)
                .field("rating", .int)
                .field("likes", .int)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(Review.schema).delete()
        }
    }
}
