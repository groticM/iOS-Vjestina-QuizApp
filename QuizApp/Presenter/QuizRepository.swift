//
//  QuizRepository.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.05.2021..
//

import Foundation

class QuizRepository {
    public var quizzesViewController : QuizzesViewController?
    private var localData : QuizDatabaseDataSource = QuizDatabaseDataSource()
    private var apiData : QuizNetworkDataSource = QuizNetworkDataSource()
    
    public func getQuizzes(){
        
        let backgroundQueue = DispatchQueue(label: "login", qos: .userInitiated, attributes: .concurrent)
        backgroundQueue.async {
            self.apiData.fetchQuizes(repo: self)
        }
    }
    
    public func HandleAPIResponse(quizzes: [Quiz]) {
        if(quizzes.isEmpty) {
            // fail sa api-a, ucitaj iz baze
            loadFromLocal()
            return
        }
        localData.saveToDatabase(quizzes: quizzes)
        DispatchQueue.main.sync {
            self.quizzesViewController?.getQuizes(quizzes: quizzes)
        }
    }
    
    public func loadFromLocal(){
        
    }
    
    init () {
    
    }
}
