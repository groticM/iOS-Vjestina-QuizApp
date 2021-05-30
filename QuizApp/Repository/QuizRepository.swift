//
//  QuizRepository.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.05.2021..
//

import Foundation

class QuizRepository {
    public var quizzesViewController: QuizzesViewController?
    private var localData: QuizDatabaseDataSource = QuizDatabaseDataSource()
    private var apiData: QuizNetworkDataSource = QuizNetworkDataSource()
    
    public func getQuizzes() {
        apiData.fetchQuizes(repo: self)
        
    }
    
    public func HandleAPIResponse(quizzes: [Quiz]) {
        if(quizzes.isEmpty) {
            DispatchQueue.main.sync {
                self.quizzesViewController?.getQuizes(quizzes: localData.loadFromDatabase())
            }
            
            return
            
        }
        
        localData.saveToDatabase(quizzes: quizzes)
        localData.loadFromDatabase()
        
        DispatchQueue.main.sync {
            self.quizzesViewController?.getQuizes(quizzes: quizzes)
        }
    }
}
