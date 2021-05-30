import UIKit

protocol NetworkServiceProtocol {
    
    func login(loginVC: LoginViewController, username: String, password: String)

    func fetchQuizes(repository: QuizRepository)
    
    func postResult(quizId: Int, time: Double, finalCorrectAnswers: Int) -> Bool

}
