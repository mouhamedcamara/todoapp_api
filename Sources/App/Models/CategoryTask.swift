//
//  CategoryTask.swift
//  
//
//  Created by Mouhamed Camara on 9/1/20.
//

import Fluent
import Vapor


final class CategoryTask: Model, Content
{
    static let schema = "category_taks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "category_id")
    var categoryId: UUID
    
    @Field(key: "task_id")
    var taskId: UUID

    init() { }

    init(id: UUID? = nil, categoryId: UUID, taskId: UUID)
    {
        self.id = id
        self.categoryId = categoryId
        self.taskId = taskId
    }
}
