import UIKit

protocol NetworkServiceProtocol {
    
    func login(loginViewController: LoginViewController, username: String, password: String)

    func fetchQuizes(repository: QuizRepository)
    
    func postResult(pageViewController: PageViewController, quizId: Int, time: Double, finalCorrectAnswers: Int) 

}
