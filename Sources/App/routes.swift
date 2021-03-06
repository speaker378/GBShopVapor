import Fluent
import Vapor

func routes(_ app: Application) throws {
    let userController = UserController()
    let goodsController = GoodsController()
    let reviewsController = ReviewsController()
    let shoppingController = ShoppingController()
    
    app.post("register", use: userController.register)
    app.post("change_user_data", use: userController.changeUserData)
    app.post("login", use: userController.login)
    app.post("logout", use: userController.logout)
    app.post("get_goods_list", use: goodsController.getGoodsList)
    app.post("get_good_by_id", use: goodsController.getGoodById)
    app.post("get_reviews", use: reviewsController.getReviews)
    app.post("add_review", use: reviewsController.addReview)
    app.post("remove_review", use: reviewsController.removeReview)
    app.post("add_to_cart", use: shoppingController.addToCart)
    app.post("remove_from_cart", use: shoppingController.removeFromCart)
    app.post("pay_cart", use: shoppingController.payCart)
    app.post("get_cart", use: shoppingController.getCart)
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
