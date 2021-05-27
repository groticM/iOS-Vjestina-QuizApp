//
//  QuizDatabaseDataSource.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.05.2021..
//

import Foundation
import CoreData

class QuizDatabaseDataSource {
    public var repo: QuizRepository?
    public var core: CoreDataStack = CoreDataStack(modelName: "QuizModel")
    
    init() {
        
    }
    public func saveToDatabase(quizzes: [Quiz]) {
        clearDatabase()
        for quiz in quizzes {
            let q = QuizEntity(context: core.managedContext)
            q.id = UUID(uuidString: String(quiz.id))
            q.title = quiz.title
            q.desc = quiz.description
            q.category = quiz.category.rawValue
            q.level = Int32(quiz.level)
            q.image = quiz.imageUrl
            for question in quiz.questions {
                let qu = QuestionEntity(context: core.managedContext)
                qu.id = UUID(uuidString: String(question.id))
                qu.answers = question.answers
                qu.correctAnswer = Int32(question.correctAnswer)
            }
        }
        core.saveContext()
    }

    func clearDatabase() {
        let entities = core.storeContainer.managedObjectModel.entities
        for entity in entities {
            delete(entityName: entity.name!)
        }
    }

    func delete(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try core.storeContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    public func loadFromDatabase() -> [Quiz] {
        return []
    }
}
