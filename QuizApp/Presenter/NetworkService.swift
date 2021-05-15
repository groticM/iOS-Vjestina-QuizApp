//
//  NetworkService.swift
//  QuizApp
//
//  Created by Marta Grotic on 14.05.2021..
//
import UIKit

class NetworkService: NetworkServiceProtocol {
    
    private var loginStatus: Bool?
    private var quizzes: [Quiz]?
    
    public let defaults = UserDefaults.standard
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print(response)
            
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
    
    func login(username: String, password: String) -> Bool {
        guard let url = URL(string: "https://iosquiz.herokuapp.com/api/session?username=\(username)&password=\(password)") else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.executeUrlRequest(request) { (result: Result<Login, RequestError>) in
            switch result {
            case .failure(let error):
                self.loginStatus = false
                print(error)
            case .success(let value):
                self.loginStatus = true
                print(value)
                
                self.defaults.set(value.token, forKey: "Token")
                self.defaults.set(value.user_id, forKey: "UserID")
                
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
                print(error)
            case .success(let value):
                //print(value)
                self.quizzes = value.quizzes.sorted{ $0.category.rawValue < $1.category.rawValue }.sorted{ $0.title < $1.title }
            }
        }
        guard let quizzes = quizzes else { return [] }

        return quizzes
    }
}
