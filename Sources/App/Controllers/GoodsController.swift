//
//  GoodsController.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Vapor
import Foundation

class GoodsController {
    func getGoodById(_ req: Request) throws -> EventLoopFuture<GoodByIdResponse> {
        guard let body = try? req.content.decode(GoodByIdRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let goods = Product.query(on: req.db).all()
        let result: EventLoopFuture<GoodByIdResponse> = goods.map { (goods: [Product]) -> GoodByIdResponse in
            let filtered = goods.filter { $0.id == body.productId }
            
            guard !filtered.isEmpty else {
                return GoodByIdResponse(
                    result: 0,
                    productName: nil,
                    price: nil,
                    description: nil,
                    errorMessage: "No such product"
                )
            }
            
            let product = filtered.first!
            return GoodByIdResponse(
                result: 1,
                productName: product.productName,
                price: product.price,
                description: product.description,
                errorMessage: nil
            )
        }
        return result
    }
    
    func getGoodsList(_ req: Request) throws -> EventLoopFuture<GoodsListResponse> {
        guard let body = try? req.content.decode(GoodsListRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let goods = Product.query(on: req.db).all()
        let result: EventLoopFuture<GoodsListResponse> = goods.map { (goods: [Product]) -> GoodsListResponse in
            let filtered = goods.filter { $0.categoryId == body.categoryId }
                .map { GoodsListItem(
                    productId: $0.id!,
                    productName: $0.productName,
                    price: $0.price
                )
                }
            guard !filtered.isEmpty else {
                return GoodsListResponse(
                    result: 0,
                    pageNumber: nil,
                    products: nil,
                    errorMessage: "No goods with such category Id"
                )
            }
            return GoodsListResponse(
                result: 1,
                pageNumber: body.pageNumber,
                products: filtered,
                errorMessage: nil
            )
        }
        return result
    }
}
