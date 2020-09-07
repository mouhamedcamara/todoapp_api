//
//  DetailController.swift
//  
//
//  Created by Mouhamed Camara on 9/4/20.
//


import Fluent
import Vapor

struct DetailController: RouteCollection
{
    func boot(routes: RoutesBuilder) throws
    {
        let details = routes.grouped("details")
        details.get(use: index)
        details.post(use: create)
        details.group(":detailID") { detail in
            detail.delete(use: delete)
            detail.put(use: update)
            detail.get(use: read)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Detail]>
    {
        return Detail.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Detail>
    {
        let detail = try req.content.decode(Detail.self)
        return detail.save(on: req.db).map { detail }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Detail>
    {
        return Detail.find(req.parameters.get("detailID"), on: req.db)
                .unwrap(or: Abort(.notFound))
    }
    
    struct PatchDetailRequestBody: Content
    {
        let description: String?
        let task_id: UUID?
    }

    func update(req: Request) throws -> EventLoopFuture<Detail>
    {
        let patchDetailRequestBody = try req.content.decode(PatchDetailRequestBody.self)
        
        return Detail.find(req.parameters.get("detailID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { detail in
                    if let description = patchDetailRequestBody.description
                    {
                        detail.$description.value = description
                    }
                    if let task_id = patchDetailRequestBody.task_id
                    {
                        detail.$task.id = task_id
                    }
                    return detail.update(on: req.db)
                        .transform(to: detail)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>
    {
        return Detail.find(req.parameters.get("detailID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
