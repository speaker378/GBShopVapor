//
//  Product.swift
//  
//
//  Created by Сергей Черных on 01.06.2022.
//

import Fluent
import Vapor

final class Product: Model {
    
    static let schema = "products"
    
    @ID(custom: "id") var id: Int?
    @Field(key: "product_name") var productName: String
    @Field(key: "product_description") var productDescription: String
    @Field(key: "category_id") var categoryId: Int
    @Field(key: "brand_id") var brandId: Int
    @Field(key: "price") var price: Double
    @Field(key: "discount") var discount: Double
    @Field(key: "quantity") var quantity: Int
    
    
    init() { }
}

extension Product: Content {
    convenience init(id: Int, productName: String, productDescription: String, categoryId: Int, brandId: Int, price: Double, discount: Double, quantity: Int) {
        self.init()
        self.id = id
        self.productName = productName
        self.productDescription = productDescription
        self.categoryId = categoryId
        self.brandId = brandId
        self.price = price
        self.discount = discount
        self.quantity = quantity
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case productDescription = "product_description"
        case categoryId = "category_id"
        case brandId = "brand_id"
        case price
        case discount
        case quantity
    }
}
