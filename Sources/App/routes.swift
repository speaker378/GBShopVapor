import Fluent
import Vapor

func routes(_ app: Application) throws {
    let userController = UserController()
    let goodsController = GoodsController()
    
    app.post("register", use: userController.register)
    app.post("change_user_data", use: userController.changeUserData)
    app.post("login", use: userController.login)
    app.post("logout", use: userController.logout)
    app.post("get_goods_list", use: goodsController.getGoodsList)
    app.post("get_good_by_id", use: goodsController.getGoodById)
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
