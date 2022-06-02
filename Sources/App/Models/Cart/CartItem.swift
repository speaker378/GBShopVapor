//
//  CartItem.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Fluent
import Vapor

final class CartItem: Model {
    
    static let schema = "carts"
    
    @ID(custom: "id") var id: Int?
    @Field(key: "product_id") var productId: Int
    @Field(key: "user_id") var userId: Int
    @Field(key: "quantity") var quantity: Int
    
    init() { }
}

extension CartItem: Content {
    convenience init(id: Int, productId: Int, userId: Int, quantity: Int) {
        self.init()
        self.id = id
        self.productId = productId
        self.userId = userId
        self.quantity = quantity
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case userId = "user_id"
        case quantity
    }
}
