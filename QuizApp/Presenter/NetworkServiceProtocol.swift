import UIKit

protocol NetworkServiceProtocol {
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void)
    
    //func login(email: String, password: String) -> LoginStatus

    //func fetchQuizes() -> [Quiz]

}
