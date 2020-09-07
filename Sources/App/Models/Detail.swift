//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 9/3/20.
//

import Fluent
import Vapor

extension FieldKey
{
    static var description: Self { "description" }
}

final class Detail: Model, Content {

    static let schema = "details"

    @ID()
    var id: UUID?
    
    @Parent(key: .taskId)
    var task: Task
    
    @Field(key: .description)
    var description: String

    init() { }

    init(id: UUID? = nil, description: String, taskId: UUID)
    {
        self.id = id
        self.description = description
        self.$task.id = taskId
    }
}
