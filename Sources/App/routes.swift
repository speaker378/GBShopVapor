import Fluent
import Vapor

func routes(_ app: Application) throws {
    let controller = UserController()
    
    app.post("register", use: controller.register)
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
