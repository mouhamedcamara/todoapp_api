import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: CategoryController())
    try app.register(collection: TaskController())
    try app.register(collection: TagController())
    try app.register(collection: DetailController())


}
