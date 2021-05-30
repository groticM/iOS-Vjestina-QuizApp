//
//  NetworkService.swift
//  QuizApp
//
//  Created by Marta Grotic on 14.05.2021..
//

import UIKit
import Reachability

class QuizNetworkDataSource: NetworkServiceProtocol {
    public let reach = Reachability.forInternetConnection()
    public let defaults = UserDefaults.standard
    
    private func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
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
    
    private func executeUrlRequestPostResult<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse  else {
                completionHandler(.failure(.serverError))
                return
            }
            
            let status = httpResponse.statusCode
            completionHandler(.success(status as! T))
            
        }
        
        dataTask.resume()
    }
    
    func login(loginViewController: LoginViewController, username: String, password: String) {
        guard let reachable = reach?.isReachable() else { return }
        
        if reachable {
            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session") else { return }
            let bodyData = "username=\(username)&password=\(password)"
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            
            self.executeUrlRequest(request) { (result: Result<Login, RequestError>) in
                switch result {
                case .failure(_):
                    loginViewController.loginAPIResult(result: false)
                case .success(let value):
                    self.defaults.set(value.token, forKey: "Token")
                    self.defaults.set(value.user_id, forKey: "UserID")
                    loginViewController.loginAPIResult(result: true)
                    
                }
            }
        }
    }
    
    func fetchQuizes(repository: QuizRepository) {
        guard let reachable = reach?.isReachable() else { return }
        
        if reachable {
            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            self.executeUrlRequest(request) { (result: Result<Quizzes, RequestError>) in
                switch result {
                case .failure(let error):
                    print("Error: \(error)")
                    repository.handleAPIResponse(quizzes: [])
                case .success(let value):
                    let quizList = value.quizzes.sorted{ $0.category.rawValue < $1.category.rawValue }.sorted{ $0.title < $1.title }
                    repository.handleAPIResponse(quizzes: quizList)
                    
                }
            }
        }
    }
    
    func postResult(pageViewController: PageViewController, quizId: Int, time: Double, finalCorrectAnswers: Int) {
        guard let reachable = reach?.isReachable() else { return  }
        
        if reachable {
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
                    pageViewController.apiResult(result: false)
                case .success(let value):
                    print(value)
                    pageViewController.apiResult(result: true)
                }

            }            
        }
    }
}
