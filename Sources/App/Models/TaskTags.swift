//
//  File.swift
//  
//
//  Created by Mouhamed Camara on 9/3/20.
//

import Foundation
import Vapor
import Fluent



final class TaskTags: Model
{

    static let schema = "task_tags"
    
    @ID()
    var id: UUID?
    
    @Parent(key: .taskId)
    var task: Task
    
    @Parent(key: .tagId)
    var tag: Tag
    
    
    
    @Field(key: .important)
    var important: Bool
    
    
    init() {}
    
    init(taskId: UUID, tagId: UUID, important: Bool) {
        self.$task.id = taskId
        self.$tag.id = tagId
        self.important = important
    }
}
