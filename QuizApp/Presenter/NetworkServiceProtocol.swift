import UIKit

protocol NetworkServiceProtocol {
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void)
    
    func executeUrlRequestPostResult<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void)
    
    func login(username: String, password: String) -> LoginStatus

    func fetchQuizes() -> [Quiz]?
    
    func postResult(quizId: Int, time: Double, finalCorrectAnswers: Int) -> Bool

}
