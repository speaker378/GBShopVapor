//
//  ShoppingController.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import FluentPostgresDriver
import Vapor
import os

class ShoppingController {
    func addToCart(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(AddToCartRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        guard body.quantity > 0 else {
            let result = DefaultResponse(
                result: 0,
                userMessage: nil,
                errorMessage: "Wrong quantity"
            )
            return req.eventLoop.makeSucceededFuture(result)
        }

        let result = CartItem.query(on: req.db)
            .all()
            .map { (items: [CartItem]) -> DefaultResponse in
                let filtered = items.filter { $0.id == body.productId && $0.userId == body.userId }
                guard filtered.count < 2 else {
                    return DefaultResponse(
                        result: 0,
                        userMessage: nil,
                        errorMessage: "Error adding to Cart"
                    )
                }
                
                if filtered.count == 1 {
                    filtered[0].quantity += body.quantity
                    let _ = filtered[0].update(on: req.db)
                } else {
                    let filtered = CartItem(
                        id: items.count + 1,
                        productId: body.productId,
                        userId: body.userId,
                        quantity: body.quantity
                    )
                    let _ = filtered.create(on: req.db)
                }
                let response = DefaultResponse(
                    result: 1,
                    userMessage: "Successfully add to cart",
                    errorMessage: nil
                )
                return response
            }
        return result
    }
}
