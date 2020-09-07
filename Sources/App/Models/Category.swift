//
//  Category.swift
//  
//
//  Created by Mouhamed Camara on 9/1/20.
//

import Fluent
import Vapor

final class Category: Model, Content
{
    static let schema = "categories"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "activated")
    var activated: Bool
    
    @Children(for: \.$category)
    var tasks: [Task]


    init() { }

    // 2.) Update the initializer
    init(id: UUID? = nil, title: String, activated: Bool = false)
    {
        self.id = id
        self.title = title
        self.activated = activated
    }
}
