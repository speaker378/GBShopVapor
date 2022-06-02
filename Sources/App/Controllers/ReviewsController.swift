//
//  ReviewsController.swift
//  
//
//  Created by Сергей Черных on 02.06.2022.
//

import Vapor

class ReviewsController {
    func getReviews(_ req: Request) throws -> EventLoopFuture<GetReviewsResponse> {
        guard let body = try? req.content.decode(GetReviewsRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let reviews = Review.query(on: req.db).all()
        let result: EventLoopFuture<GetReviewsResponse> = reviews.map { (reviews: [Review]) -> GetReviewsResponse in
            let filtered = reviews.filter { $0.productId == body.productId }
            
            return GetReviewsResponse(
                result: 1,
                reviews: filtered,
                errorMessage: nil
            )
        }
        return result
    }
    
    func addReview(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(AddReviewRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let allReviews = Review.query(on: req.db).all()
        let result: EventLoopFuture<DefaultResponse> = allReviews.map { (reviews: [Review]) -> DefaultResponse in
            let filtered = reviews.filter { $0.userId == body.userId && $0.productId == body.productId }
            
            guard filtered.isEmpty else {
                return DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "User already post a review"
                )
            }
            
            let review = Review(
                id: reviews.count + 1,
                productId: body.productId,
                userId: body.userId,
                text: body.text,
                rating: body.rating,
                likes: 0
            )
            
            let _ = review.create(on: req.db)
            return DefaultResponse(
                result: 1,
                userMessage: "Review is on moderation",
                errorMessage: nil
            )
        }
        return result
    }
    
    func removeReview(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(RemoveReviewRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let allReviews = Review.query(on: req.db).all()
        let result: EventLoopFuture<DefaultResponse> = allReviews.map { (reviews: [Review]) -> DefaultResponse in
            let filtered = reviews.filter { $0.id == body.reviewId }
            
            guard !filtered.isEmpty else {
                return DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "Wrong reviewId"
                )
            }
            
            let _ = filtered[0].delete(on: req.db)
            return DefaultResponse(
                result: 1,
                userMessage: "Review successfully removed",
                errorMessage: nil
            )
        }
        return result
    }
}
