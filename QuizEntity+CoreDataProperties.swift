//
//  QuizEntity+CoreDataProperties.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.05.2021..
//
//

import Foundation
import CoreData


extension QuizEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizEntity> {
        return NSFetchRequest<QuizEntity>(entityName: "QuizEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var level: Int32
    @NSManaged public var title: String?
    @NSManaged public var question: NSSet?

}

// MARK: Generated accessors for question
extension QuizEntity {

    @objc(addQuestionObject:)
    @NSManaged public func addToQuestion(_ value: QuestionEntity)

    @objc(removeQuestionObject:)
    @NSManaged public func removeFromQuestion(_ value: QuestionEntity)

    @objc(addQuestion:)
    @NSManaged public func addToQuestion(_ values: NSSet)

    @objc(removeQuestion:)
    @NSManaged public func removeFromQuestion(_ values: NSSet)

}

extension QuizEntity : Identifiable {

}
