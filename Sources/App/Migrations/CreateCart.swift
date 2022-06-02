//
//  CreateCart.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Fluent

extension CartItem {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database
                .schema(CartItem.schema)
                .field("id", .int)
                .field("product_id", .int)
                .field("user_id", .int)
                .field("quantity", .int)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(CartItem.schema).delete()
        }
    }
}
