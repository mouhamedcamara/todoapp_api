//
//  Tag.swift
//  
//
//  Created by Mouhamed Camara on 9/3/20.
//

import Vapor
import Fluent


extension FieldKey
{
    static var name: Self { "name" }
    static var taskId: Self { "task_id" }
    static var tagId: Self { "tag_id" }
    static var important: Self { "important" }
}

final class Tag: Model, Content
{

    static let schema = "tags"

    @ID()
    var id: UUID?
    
    @Field(key: .name)
    var name: String
    
    @Siblings(through: TaskTags.self, from: \.$tag, to: \.$task)
    var tasks: [Task]
        
    
    
    init() { }

    init(id: UUID? = nil, name: String)
    {
        self.id = id
        self.name = name
    }
}
