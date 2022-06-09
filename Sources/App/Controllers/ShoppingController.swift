//
//  ShoppingController.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import FluentPostgresDriver
import Vapor

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
                let filtered = items.filter { $0.productId == body.productId && $0.userId == body.userId }
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
    
    func removeFromCart(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(RemoveFromCartRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let cartItems = CartItem.query(on: req.db).all()
        let result: EventLoopFuture<DefaultResponse> = cartItems.map { (items: [CartItem]) -> DefaultResponse in
            let filtered = items.filter { $0.userId == body.userId && $0.productId == body.productId}
            guard filtered.count == 1 else {
                return DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "Error removing from cart"
                )
            }
            
            let quantityToRemove = body.quantity == nil ? filtered[0].quantity : body.quantity!
            filtered[0].quantity = max(0, filtered[0].quantity - quantityToRemove)
            if filtered[0].quantity == 0 {
                let _ = filtered[0].delete(on: req.db)
            } else {
                let _ = filtered[0].update(on: req.db)
            }
            let response = DefaultResponse(
                result: 1,
                userMessage: "Successfully remove from cart",
                errorMessage: nil
            )
            return response
        }
        return result
    }
    
    func payCart(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(PayCartRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let negativeResponse = DefaultResponse(
            result: 0,
            userMessage: nil,
            errorMessage: "Wrong quantity"
        )
        let positiveResponse = DefaultResponse(
            result: 1,
            userMessage: "Successfully paid the Cart",
            errorMessage: nil
        )
        
        let result = Product.query(on: req.db)
            .join(CartItem.self, on: \Product.$id == \CartItem.$productId)
            .filter(CartItem.self, \.$userId == body.userId)
            .all()
            .map { (products: [Product]) -> DefaultResponse in
                guard !products.isEmpty else {
                    return DefaultResponse(
                        result: 0,
                        userMessage: nil,
                        errorMessage: "The Cart is empty"
                    )
                }
                
                var canBuyAllItems = true
                products.forEach { product in
                    do {
                        let cart = try product.joined(CartItem.self)
                        canBuyAllItems = canBuyAllItems && (product.quantity >= cart.quantity)
                        print("Quantity: \(product.quantity)")
                        print("Quantity in cart: \(cart.quantity)")
                    }
                    catch _ { }
                }
                print(canBuyAllItems)
                var result: DefaultResponse = negativeResponse
                if canBuyAllItems {
                    products.forEach { product in
                        do {
                            let cart = try product.joined(CartItem.self)
                            product.quantity -= cart.quantity
                            let _ = product.update(on: req.db)
                            let _ = cart.delete(on: req.db)
                            result = positiveResponse
                        }
                        catch _ { }
                    }
                }
                return result
            }
        return result
    }
    
    func getCart(_ req: Request) throws -> EventLoopFuture<GetCartResponse> {
        guard let body = try? req.content.decode(GetCartRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let result = Product.query(on: req.db)
            .join(CartItem.self, on: \Product.$id == \CartItem.$productId)
            .filter(CartItem.self, \.$userId == body.userId)
            .all()
            .map { (products: [Product]) -> GetCartResponse in
                guard !products.isEmpty else {
                    return GetCartResponse(
                        result: 0,
                        products: nil,
                        totalPrice: nil,
                        errorMessage: "The Cart is empty"
                    )
                }
                
                var cartListItems: [CartListItem] = []
                var totalPrice: Double = 0
                
                products.forEach { product in
                    do {
                        let cart = try product.joined(CartItem.self)
                        cartListItems.append(CartListItem(
                            productId: product.id!,
                            productName: product.productName,
                            price: product.price,
                            quantity: cart.quantity
                        ))
                        totalPrice += product.price * Double(cart.quantity)
                    }
                    catch _ { }
                }
                
                return GetCartResponse(result: 1, products: cartListItems, totalPrice: totalPrice, errorMessage: nil)
        }
        return result
    }
}
