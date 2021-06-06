//
//  QuizEntity+CoreDataProperties.swift
//  QuizApp
//
//  Created by Marta Grotic on 30.05.2021..
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
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension QuizEntity {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuestionEntity)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuestionEntity)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}

extension QuizEntity : Identifiable {

}
