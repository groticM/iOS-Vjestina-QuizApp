//
//  QuestionEntity+CoreDataProperties.swift
//  QuizApp
//
//  Created by Marta Grotic on 30.05.2021..
//
//

import Foundation
import CoreData


extension QuestionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionEntity> {
        return NSFetchRequest<QuestionEntity>(entityName: "QuestionEntity")
    }

    @NSManaged public var answers: [String]?
    @NSManaged public var correctAnswer: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var question: String?
    @NSManaged public var quiz: QuizEntity?

}

extension QuestionEntity : Identifiable {

}
