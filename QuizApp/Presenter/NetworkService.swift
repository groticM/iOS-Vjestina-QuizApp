//
//  NetworkService.swift
//  QuizApp
//
//  Created by Marta Grotic on 14.05.2021..
//

import UIKit
import Reachability

class NetworkService: NetworkServiceProtocol {
    
    private var loginStatus: Bool?
    private var quizzes: [Quiz]?
    
    var reach: Reachability?
    var connectionStatus: Bool?
    
    public let defaults = UserDefaults.standard
    
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
    
    func executeUrlRequestPostResult<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            var statusCode: ServerAnswers?
            switch httpResponse.statusCode {
            case 200:
                statusCode = ServerAnswers.ok
            case 400:
                statusCode = ServerAnswers.badRequest
            case 401:
                statusCode = ServerAnswers.unauthorized
            case 403:
                statusCode = ServerAnswers.forbidden
            case 404:
                statusCode = ServerAnswers.notFound
            default:
                statusCode = ServerAnswers.error
            }
            
            guard let status = statusCode else { return }
            completionHandler(.serverAnswer(status))
        }
        
        dataTask.resume()
    }
    
    func login(username: String, password: String) -> Bool {
        connection()
        //print(self.connectionStatus)

        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session") else { return false }
        let bodyData = "username=\(username)&password=\(password)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        self.executeUrlRequest(request) { (result: Result<Login, RequestError>) in
            switch result {
            case .failure(let error):
                self.loginStatus = false
                print("Error: \(error)")
            case .success(let value):
                self.loginStatus = true
                self.defaults.set(value.token, forKey: "Token")
                self.defaults.set(value.user_id, forKey: "UserID")
            case .serverAnswer(let code):
                print("Status code: \(code)")
                
            }
        }
        
        guard let loginStatus = loginStatus else { return false }
        
        return loginStatus
        
    }
    
    func fetchQuizes() -> [Quiz] {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return [] }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        self.executeUrlRequest(request) { (result: Result<Quizzes, RequestError>) in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let value):
                self.quizzes = value.quizzes.sorted{ $0.category.rawValue < $1.category.rawValue }.sorted{ $0.title < $1.title }
            case .serverAnswer(let code):
                print("Status code: \(code)")
                
            }
        }
        guard let quizzes = quizzes else { return [] }

        return quizzes
    }
    
    func postResult(quizId: Int, time: Double, finalCorrectAnswers: Int) {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }

        guard let token = defaults.object(forKey: "Token") else { return }
        guard let userId = defaults.object(forKey: "UserID") else { return }
        
        let parameters: [String: Any] = [
            "quiz_id": quizId,
            "user_id": userId,
            "time": time,
            "no_of_correct": finalCorrectAnswers
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        self.executeUrlRequestPostResult(request) { (result: Result<Int, RequestError>) in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let value):
                print(value)
            case .serverAnswer(let code):
                print("Status code: \(code.rawValue)")
            }
            
        }
    }
    
    func connection() {
        self.reach = Reachability.forInternetConnection()
        
        self.reach!.reachableBlock = { (reach: Reachability?) -> Void in
            print("REACHABLE!")
            self.connectionStatus = true
            
        }
            
        self.reach!.unreachableBlock = { (reach: Reachability?) -> Void in
            print("UNREACHABLE!")
            self.connectionStatus = false
                
        }
            
        self.reach!.startNotifier()

        
    }
}
