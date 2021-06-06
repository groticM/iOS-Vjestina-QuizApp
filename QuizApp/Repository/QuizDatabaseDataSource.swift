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
                qu.question = question.question
                qu.correctAnswer = Int32(question.correctAnswer)
                q.addToQuestions(qu)
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
        var quizzes = [Quiz]()
        let request: NSFetchRequest<QuizEntity> = QuizEntity.fetchRequest()
        
        do {
            let results = try core.managedContext.fetch(request)
            
            var numOfQuiz = 0
            for entity in results {
                var quiz: Quiz! = Quiz()
                quiz?.title = entity.title ?? ""
                quiz.description = entity.desc ?? ""
                quiz.category = QuizCategory(rawValue: entity.category ?? "" ) ?? QuizCategory.none
                quiz.level = Int(entity.level)
                quiz.imageUrl = entity.image ?? ""
                quiz.id = numOfQuiz
                
                numOfQuiz += 1
                
                var numOfQuestion = 0
                for questionEntiy in entity.questions?.allObjects ?? [] {
                    var question : Question! = Question()
                    question.question = (questionEntiy as! QuestionEntity).question!
                    question.answers = (questionEntiy as! QuestionEntity).answers!
                    question.correctAnswer = Int((questionEntiy as! QuestionEntity).correctAnswer)
                    quiz.questions.append(question)
                    question.id = numOfQuestion
                    numOfQuestion += 1
                }
                
                quizzes.append(quiz)
            }
            return quizzes
            
        } catch {
            print("Fetching data Failed")
        }
        return []
    }
    
    public func filterLoadFromDatabase(filter: String) -> [Quiz] {
        var quizzes = [Quiz]()
        let request: NSFetchRequest<QuizEntity> = QuizEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(QuizEntity.title), filter)
        
        do {
            let results =  try core.managedContext.fetch(request)
            
            var numOfQuiz = 0
            for entity in results {
                var quiz: Quiz! = Quiz()
                quiz?.title = entity.title ?? ""
                quiz.description = entity.desc ?? ""
                quiz.category = QuizCategory(rawValue: entity.category ?? "" ) ?? QuizCategory.none
                quiz.level = Int(entity.level)
                quiz.imageUrl = entity.image ?? ""
                quiz.id = numOfQuiz
                
                numOfQuiz += 1
                
                var numOfQuestion = 0
                for questionEntiy in entity.questions?.allObjects ?? [] {
                    var question : Question! = Question()
                    question.question = (questionEntiy as! QuestionEntity).question!
                    question.answers = (questionEntiy as! QuestionEntity).answers!
                    question.correctAnswer = Int((questionEntiy as! QuestionEntity).correctAnswer)
                    quiz.questions.append(question)
                    question.id = numOfQuestion
                    numOfQuestion += 1
                }
                
                quizzes.append(quiz)
            }
            
            return quizzes
            
        } catch {
            print("Error when fetching restaurants from core data: \(error)")
            return []
        }
    }
}
