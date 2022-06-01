import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    let databaseURL = Environment.get("DATABASE_URL") ?? "postgres://kzoqfxttifhcuf:872bd6663a0f1487ca96726d71004c8aa8c74d69cd6bb7e2627d39a75401e287@ec2-54-228-32-29.eu-west-1.compute.amazonaws.com:5432/dbtohqil5l40qa"
    
    if var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        postgresConfig.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        // ...
    }
    
    // register routes
    try routes(app)
}
