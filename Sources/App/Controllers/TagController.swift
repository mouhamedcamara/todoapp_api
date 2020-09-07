//
//  TagController.swift
//  
//
//  Created by Mouhamed Camara on 9/4/20.
//

import Fluent
import Vapor

struct TagController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let tags = routes.grouped("tags")
        tags.get(use: index)
        tags.get("tasks", ":tagID", use: tasks)
        tags.post(use: create)
        tags.group(":tagID") { tag in
            tag.delete(use: delete)
            tag.put(use: update)
            tag.get(use: read)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Tag]>
    {
        return Tag.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Tag>
    {
        let tag = try req.content.decode(Tag.self)
        return tag.save(on: req.db).map { tag }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Tag>
    {
        return Tag.find(req.parameters.get("tagID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }
    
    struct PatchTagRequestBody: Content
    {
        let name: String?
    }

    func update(req: Request) throws -> EventLoopFuture<Tag>
    {
        let patchTagRequestBody = try req.content.decode(PatchTagRequestBody.self)
        
        return Tag.find(req.parameters.get("tagID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { tag in
                    if let name = patchTagRequestBody.name
                    {
                        tag.name = name
                    }
                    return tag.update(on: req.db)
                        .transform(to: tag)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>
    {
        return Tag.find(req.parameters.get("tagID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func tasks(req: Request) throws -> EventLoopFuture<[Task]>
    {        return Task
                .query(on: req.db)
            .join(TaskTags.self, on: \TaskTags.$task.$id
                == \Task.$id, method: .inner)
            .filter(TaskTags.self, \.$tag.$id == UUID(uuidString: req.parameters.get("tagID")!)!)
            .all()
    }
}
