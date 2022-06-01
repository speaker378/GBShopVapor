import Fluent
import Vapor

func routes(_ app: Application) throws {
    let controller = UserController()
    
    app.post("register", use: controller.register)
    app.post("change_user_data", use: controller.changeUserData)
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
