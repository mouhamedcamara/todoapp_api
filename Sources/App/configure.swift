import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.mysql(
        hostname: "localhost",
        port: 3333,
        username: "camou",
        password: "camou",
        database: "todolist",
        tlsConfiguration: nil,
        maxConnectionsPerEventLoop: 1
    ), as: .mysql)

    app.migrations.add(CreateCategory())

    try app.autoMigrate().wait()

    //Initiate
    
//    let course = Category(title: "Course")
//    let shoplist = Category(title: "Shoplist")
//    let project = Category(title: "Awesome Fluent project")
//    try [course, shoplist, project].create(on: app.db).wait()
//
//    let family = Tag(name: "family")
//    let work = Tag(name: "work")
//    
//    
//    try [family, work].create(on: app.db).wait()
//
//    let smoothie = Task(title: "Make a smoothie",
//                        note: "Travailler sur ce projet comme si ma vie en dépend",
//                        status: .pending,
//                        labels: [.orange],
//                        due: Date(timeIntervalSinceNow: 3600),
//                        categoryID: course.id!)
//
//    let apples = Task(title: "Apples", note: "Travailler sur ce projet comme si ma vie en dépend", categoryID: shoplist.id!)
//    let bananas = Task(title: "Bananas", note: "Travailler sur ce projet comme si ma vie en dépend", categoryID: shoplist.id!)
//    let mango = Task(title: "Mango", note: "Travailler sur ce projet comme si ma vie en dépend", categoryID: shoplist.id!)
//    
//    
//
//    let kickoff = Task(title: "Kickoff meeting",
//                       note: "Travailler sur ce projet comme si ma vie en dépend",
//                       status: .completed,
//                       categoryID: project.id!)
//
//    let code = Task(title: "Code in Swift",
//                    note: "Travailler sur ce projet comme si ma vie en dépend",
//                    labels: [.green],
//                    categoryID: project.id!)
//
//    let deadline = Task(title: "Project deadline",
//                        note: "Travailler sur ce projet comme si ma vie en dépend",
//                        labels: [.red],
//                        due: Date(timeIntervalSinceNow: 86400 * 7),
//                        categoryID: project.id!)
//
//    
//    try [smoothie, apples, bananas, mango, kickoff, code, deadline].create(on: app.db).wait()
//
//    let detail = Detail(description: "Travailler sur ce projet comme si ma vie en dépend", taskId: apples.id!)
//    try detail.create(on: app.db).wait()
//    
//    let familySmoothie = TaskTags(taskId: smoothie.id!, tagId: family.id!, important: true)
//    let workDeadline = TaskTags(taskId: deadline.id!, tagId: work.id!, important: false)
//
//    try [familySmoothie, workDeadline].create(on: app.db).wait()
//    
    
    try routes(app)
}
