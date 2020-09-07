//
//  CreateCategory.swift
//  
//
//  Created by Mouhamed Camara on 9/1/20.
//

import Fluent

struct CreateCategory: Migration
{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(Category.schema)
                .id()
                .field("title", .string, .required)
                .field("activated", .bool, .required, .custom("DEFAULT false"))
                .unique(on: "title")
                .create(),
            database.schema(Task.schema)
                .id()
                .field("title", .string, .required)
                .field("note", .string, .required)
                .field("status", .string, .required)
                .field("labels", .int, .required)
                .field("due", .datetime)
                .field(.categoryId, .uuid, .required)
                .foreignKey(.categoryId, references: Category.schema, .id, onDelete: .cascade, onUpdate: .noAction)
                .unique(on: "title", "category_id")
                .create(),
            database.schema(Detail.schema)
                .id()
                .field(.taskId, .uuid, .required)
                .foreignKey(.taskId, references: Task.schema, .id, onDelete: .cascade, onUpdate: .cascade)
                .field(.description, .string, .required)
                .unique(on: "description")
                .create(),
            database.schema(Tag.schema)
                .id()
                .field(.name, .string, .required)
                .unique(on: "name")
                .create(),
            database.schema(TaskTags.schema)
                .id()
                .field(.taskId, .uuid, .required)
                .field(.tagId, .uuid, .required)
                .field(.important, .bool, .required)
                .create(),
        ])
    }

    func revert(on database: Database) -> EventLoopFuture<Void>
    {
        database.eventLoop.flatten([
            database.schema(Detail.schema).delete(),
            database.schema(Task.schema).delete(),
            database.schema(Tag.schema).delete(),
            database.schema(TaskTags.schema).delete(),
            database.schema(Category.schema).delete()
        ])
        
    }
}
