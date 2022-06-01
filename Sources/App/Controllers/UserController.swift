//
//  UserController.swift
//  
//
//  Created by Сергей Черных on 31.05.2022.
//

import Vapor

class UserController {
    func register(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(User.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let users = User.query(on: req.db).all()
        let result: EventLoopFuture<DefaultResponse> = users.map { (users: [User]) -> DefaultResponse in
            let filtered = users.filter {($0.login == body.login) || ($0.email == body.email)}
            var response: DefaultResponse
            if filtered.count == 0 {
                response = DefaultResponse(
                    result: 1,
                    userMessage: "\(body.login) is registered",
                    errorMessage: nil
                )
                body.id = users.count + 1
                let _ = body.create(on: req.db)
            }
            else {
                response = DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "login or email already exists"
                )
            }
            return response
        }
        return result
    }
}
