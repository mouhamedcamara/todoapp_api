//
//  CategoryController.swift
//
//
//  Created by Mouhamed Camara on 9/2/20.
//


import Fluent
import Vapor

struct CategoryController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let categories = routes.grouped("categories")
        categories.get(use: index)
        categories.get("tasks", ":categoryID", use: tasks)
        categories.post(use: create)
        categories.group(":categoryID") { category in
            category.delete(use: delete)
            category.put(use: update)
            category.get(use: read)
//            category.get("tasks", use: tasks)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Category]>
    {
        return Category.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Category>
    {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Category>
    {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }
    
    struct PatchCategoryRequestBody: Content
    {
        let title: String?
        let activated: Bool?
    }

    func update(req: Request) throws -> EventLoopFuture<Category>
    {
        let patchCategoryRequestBody = try req.content.decode(PatchCategoryRequestBody.self)
        
        return Category.find(req.parameters.get("categoryID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { category in
                    if let title = patchCategoryRequestBody.title
                    {
                        category.title = title
                    }
                    if let activated = patchCategoryRequestBody.activated
                    {
                        category.activated = activated
                    }
                    return category.update(on: req.db)
                        .transform(to: category)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>
    {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func tasks(req: Request) throws -> EventLoopFuture<[Task]>
    {
        return  Task.query(on: req.db)
                    .join(Category.self, on: \Task.$category.$id == \Category.$id, method: .inner)
                    .filter(Category.self, \.$id == UUID(uuidString: req.parameters.get("categoryID")!)!)
                    .all()
    }
}
