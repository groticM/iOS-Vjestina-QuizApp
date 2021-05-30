//
//  NetworkService.swift
//  QuizApp
//
//  Created by Marta Grotic on 14.05.2021..
//

import UIKit
import Reachability

class QuizNetworkDataSource {
    
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
    
    func login(loginVC: LoginViewController, username: String, password: String) {
        let reachable = connection()
        
        if reachable {
             
            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session") else { return }
            let bodyData = "username=\(username)&password=\(password)"
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            
            self.executeUrlRequest(request) { (result: Result<Login, RequestError>) in
                switch result {
                case .failure(_):
                    loginVC.loginAPIResult(result: false)
                case .success(let value):
                    self.defaults.set(value.token, forKey: "Token")
                    self.defaults.set(value.user_id, forKey: "UserID")
                    loginVC.loginAPIResult(result: true)
                case .serverAnswer(let code):
                    print("Status code: \(code)")
                    loginVC.loginAPIResult(result: false)
                    
                }
            }
        }

    }
    
    func fetchQuizes(repo: QuizRepository) {
        let reachable = connection()
        
        if reachable {
            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            self.executeUrlRequest(request) { (result: Result<Quizzes, RequestError>) in
                switch result {
                case .failure(let error):
                    print("Error: \(error)")
                    repo.HandleAPIResponse(quizzes: [])
                case .success(let value):
                    let quizList = value.quizzes.sorted{ $0.category.rawValue < $1.category.rawValue }.sorted{ $0.title < $1.title }
                    repo.HandleAPIResponse(quizzes: quizList)
                case .serverAnswer(let code):
                    print("Status code: \(code)")
                    repo.HandleAPIResponse(quizzes: [])
                    
                }
            }
        }
    }
    
    func postResult(quizId: Int, time: Double, finalCorrectAnswers: Int) -> Bool {
        let reachable = connection()
        
        if reachable {
            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return false }

            guard let token = defaults.object(forKey: "Token") else { return false }
            guard let userId = defaults.object(forKey: "UserID") else { return false }
        
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
        
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return false }
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
            
            return true
            
        } else {
            return false
            
        }
    }
    
    func connection() -> Bool {
        self.reach = Reachability.forInternetConnection()
        guard let reachable = reach?.isReachable() else { return false }
        return reachable
        
    }
}
