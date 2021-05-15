import UIKit

protocol NetworkServiceProtocol {
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void)
    
    func login(username: String, password: String) -> Bool

    func fetchQuizes() -> [Quiz]

}
