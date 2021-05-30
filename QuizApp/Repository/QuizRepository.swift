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
    private var networkService: QuizNetworkDataSource = QuizNetworkDataSource()
    
    public func getQuizzes() {
        networkService.fetchQuizes(repository: self)
        
    }
    
    public func getFilteredQuizzes(text: String) -> [Quiz] {
        let quizzes = localData.filterLoadFromDatabase(filter: text)
        
        return quizzes
        
    }
    
    public func handleAPIResponse(quizzes: [Quiz]) {
        guard let reachable = networkService.reach?.isReachable() else { return }
        if !reachable {
            DispatchQueue.main.sync {
                self.quizzesViewController?.getQuizes(quizzes: localData.loadFromDatabase())
            }
            return
        }
        
        localData.saveToDatabase(quizzes: quizzes)
        let quizzesLocal = localData.loadFromDatabase()
        
        DispatchQueue.main.sync {
            self.quizzesViewController?.getQuizes(quizzes: quizzesLocal)
        }
        
    }
}
