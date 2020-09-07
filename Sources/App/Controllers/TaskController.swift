import Fluent
import Vapor

struct TaskController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let tasks = routes.grouped("tasks")
        tasks.get(use: index)
        tasks.get("details", ":taskID", use: details)
        tasks.get("tags", ":taskID", use: tags)
        tasks.post(use: create)
        tasks.group(":taskID") { task in
            task.delete(use: delete)
            task.put(use: update)
            task.get(use: read)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Task]>
    {
        return Task.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Task>
    {
        let task = try req.content.decode(Task.self)
        return task.save(on: req.db).map { task }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Task>
    {
        return Task.find(req.parameters.get("taskID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }
    
    struct PatchTaskRequestBody: Content
    {
        let title: String?
        let note: String?
        let status: String?
        let labels: Int?
        let due: Date?
        let category_id: UUID?
    }

    func update(req: Request) throws -> EventLoopFuture<Task>
    {
        let patchTaskRequestBody = try req.content.decode(PatchTaskRequestBody.self)
        
        return Task.find(req.parameters.get("taskID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { task in
                    if let title = patchTaskRequestBody.title
                    {
                        task.title = title
                    }
                    if let note = patchTaskRequestBody.note
                    {
                        task.note = note
                    }
                    if let status = patchTaskRequestBody.status
                    {
                        task.status = Task.Status(rawValue: status)!
                    }
                    if let labels = patchTaskRequestBody.labels
                    {
                        task.labels = Task.Labels(rawValue: labels)
                    }
                    if let due = patchTaskRequestBody.due
                    {
                        task.due = due
                    }
                    if let catID = patchTaskRequestBody.category_id
                    {
                        task.$category.id = catID
                    }
                    return task.update(on: req.db)
                        .transform(to: task)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>
    {
        return Task.find(req.parameters.get("taskID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func details(req: Request) throws -> EventLoopFuture<[Detail]>
    {
        return Detail
                .query(on: req.db)
                .join(Task.self, on: \Detail.$task.$id == \Task.$id, method: .inner)
                .filter(Task.self, \.$id == UUID(uuidString: req.parameters.get("taskID")!)!)
                .all()
    }
    
    func tags(req: Request) throws -> EventLoopFuture<[Tag]>
    {        return Tag
                .query(on: req.db)
            .join(TaskTags.self, on: \TaskTags.$tag.$id
                == \Tag.$id, method: .inner)
            .filter(TaskTags.self, \.$task.$id == UUID(uuidString: req.parameters.get("taskID")!)!)
            .all()
    }
}
