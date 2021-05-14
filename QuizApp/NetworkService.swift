//
//  NetworkService.swift
//  QuizApp
//
//  Created by Marta Grotic on 14.05.2021..
//
import UIKit

class NetworkService: NetworkServiceProtocol {
    
    private var loginStatus: LoginStatus?
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.dataDecodingError))
                return
            }
            
            completionHandler(.success(value))
        }
        
        dataTask.resume()
    }
    
    func login(username: String, password: String) -> LoginStatus {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session?username=\(username)&password=\(password)") else { return .error(500, "serverError") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.executeUrlRequest(request) { (result: Result<Login, RequestError>) in
            switch result {
            case .failure(let error):
                self.loginStatus = LoginStatus.error(500, error.localizedDescription)
                print(error)
            case .success(let value):
                self.loginStatus = LoginStatus.success(value.token, value.user_id)
                print(value)
            }
        }
        
        guard let loginStatus = loginStatus else { return .error(500, "serverError") }
        print(loginStatus)
        
        return loginStatus
        
    }
}
