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
    
    func changeUserData(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(User.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let users = User.query(on: req.db).all()
        let result: EventLoopFuture<DefaultResponse> = users.map { (users: [User]) -> DefaultResponse in
            guard let user = users.first(where: { $0.id == body.id }) else {
                return DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "No such user"
                )
            }
            
            let filtered = users.filter {($0.login == body.login) || ($0.email == body.email)}
            guard filtered.isEmpty else {
                return DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "login or email already exists"
                )
            }
            
            var response: DefaultResponse
            response = DefaultResponse(
                result: 1,
                userMessage: "Successfully changed user data",
                errorMessage: nil
            )
            user.login = body.login
            user.passwordHash = body.passwordHash
            user.email = body.email
            user.gender = body.gender
            user.creditCard = body.creditCard
            user.bio = body.bio
            user.name = body.name
            user.lastName = body.lastName
            let _ = user.update(on: req.db)
            
            return response
        }
        return result
    }
    
    func login(_ req: Request) throws -> EventLoopFuture<LoginResponse> {
        guard let body = try? req.content.decode(LoginRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let users = User.query(on: req.db).all()
        let result: EventLoopFuture<LoginResponse> = users.map { (users: [User]) -> LoginResponse in
            let passwordHash = Crypto.MD5(body.password)
            let users = users.filter {($0.login == body.login) && ($0.passwordHash == passwordHash)}
            guard !users.isEmpty else {
                return LoginResponse(
                    result: 0,
                    user: nil,
                    token: nil,
                    errorMessage: "Wrong login or password"
                )
            }
            
            let user = users.first!
            let token = Crypto.MD5(String(user.id!))
            user.token = token
            let userData = UserData(id: user.id!,
                                    login: user.login,
                                    name: user.name,
                                    lastName: user.lastName,
                                    email: user.email,
                                    gender: user.gender,
                                    creditCard: user.creditCard,
                                    bio: user.bio
            )
            let response = LoginResponse(
                result: 1,
                user: userData,
                token: token,
                errorMessage: nil
            )
            let _ = user.update(on: req.db)
            return response
        }
        return result
    }
    
    func logout(_ req: Request) throws -> EventLoopFuture<DefaultResponse> {
        guard let body = try? req.content.decode(LogoutRequest.self) else {
            throw Abort(.badRequest)
        }
        
        print(body)
        
        let users = User.query(on: req.db).all()
        let result: EventLoopFuture<DefaultResponse> = users.map { (users: [User]) -> DefaultResponse in
            let users = users.filter { $0.id == body.id }
            guard !users.isEmpty else {
                return DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "No such user"
                )
            }
            
            let user = users.first!
            guard user.token != nil else {
                return DefaultResponse(
                    result: 0,
                    userMessage: nil,
                    errorMessage: "User was not logged in"
                )
            }
            
            user.token = nil
            let _ = user.update(on: req.db)
            return DefaultResponse(
                result: 1,
                userMessage: "Successfully logged out!",
                errorMessage: nil
            )
        }
        return result
    }
}
