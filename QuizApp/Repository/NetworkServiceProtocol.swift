import UIKit

protocol NetworkServiceProtocol {
    
    func login(username: String, password: String)

    func fetchQuizes()
    
    func postResult(quizId: Int, time: Double, finalCorrectAnswers: Int) -> Bool

}
