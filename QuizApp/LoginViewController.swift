//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 05.04.2021..
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var emailField: UITextField!
    private var passwordField: UITextField!
    private var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
    }
    
    private func buildViews() {
        let radius: CGFloat = 25
        
        view.backgroundColor = .systemIndigo
        
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        titleLabel.textColor = .white
        
        emailField = UITextField()
        view.addSubview(emailField)
        emailField.layer.cornerRadius = radius
        emailField.text = "E-mail"
        emailField.backgroundColor = .white
        emailField.alpha = 0.2
        
        passwordField = UITextField()
        view.addSubview(passwordField)
        passwordField.layer.cornerRadius = radius
        passwordField.clipsToBounds = true
        passwordField.text = "Password"
        passwordField.textAlignment = .natural
        passwordField.backgroundColor = .white
        passwordField.alpha = 0.2
        
        loginButton = UIButton()
        view.addSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = radius
        loginButton.backgroundColor = .white
        loginButton.alpha = 0.5
        
    }
    
    private func addConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.widthAnchor.constraint(equalToConstant: 220)
        ])
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            emailField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
}
