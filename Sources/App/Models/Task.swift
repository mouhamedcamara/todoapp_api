//
//  Task.swift
//  
//
//  Created by Mouhamed Camara on 9/1/20.
//

import Fluent
import Vapor

final class Task: Model, Content
{
    static let schema = "tasks"
    
    enum Status: String, Codable
    {
        case pending
        case completed
    }

    struct Labels: OptionSet, Codable
    {
        var rawValue: Int
        
        static let red = Labels(rawValue: 1 << 0)
        static let orange = Labels(rawValue: 1 << 1)
        static let yellow = Labels(rawValue: 1 << 2)
        static let green = Labels(rawValue: 1 << 3)
        
        static let all: Labels = [
            .red,
            .orange,
            .yellow,
            .green,
        ]
    }

    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "note")
    var note: String
    
    @Field(key: "status")
    var status: Status
    
    @Field(key: "labels")
    var labels: Labels
    
    @Field(key: "due")
    var due: Date?
    
    @Parent(key: .categoryId)
    var category: Category
    
    @Children(for: \.$task)
    var details: [Detail]
    
    @Siblings(through: TaskTags.self, from: \.$task, to: \.$tag)
    var tags: [Tag]

    init() { }

    // 2.) Update the initializer
    init(
        id: UUID? = nil,
        title: String,
        note: String,
        status: Status = .pending,
        labels: Labels = [],
        due: Date? = nil,
        categoryID: UUID)
    {
        self.id = id
        self.title = title
        self.note = note
        self.status = status
        self.labels = labels
        self.due = due
        self.$category.id = categoryID
    }
}

extension FieldKey {
    static var categoryId: Self { "category_id" }
//    static var description: Self { "description" }
}
