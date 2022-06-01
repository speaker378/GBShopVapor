//
//  CreateProduct.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Fluent

extension Product {
    struct Create: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database
                .schema(Product.schema)
                .field("id", .int)
                .field("product_name", .string)
                .field("product_description", .string)
                .field("category_id", .int)
                .field("brand_id", .int)
                .field("price", .double)
                .field("discount", .double)
                .field("quantity", .int)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(Product.schema).delete()
        }
    }
}
