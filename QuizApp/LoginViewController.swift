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
    
    private let defaultTextFieldAlpha: CGFloat = 0.3
    private let defaultButtonAlpha: CGFloat = 0.5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
    }
    
    private func buildViews() {
        let radius: CGFloat = 25
        
        view.backgroundColor = .systemTeal
        
        //Title label
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        titleLabel.textColor = .white
        
        //E-mail field
        emailField = UITextField()
        view.addSubview(emailField)
        designTextField(target: emailField, text: "E-mail", radius: radius)
        emailField.addTarget(self, action: #selector(updateEmail), for: .editingDidBegin)
        emailField.addTarget(self, action: #selector(doneEmail), for: .editingDidEnd)
        
        //Password field
        passwordField = UITextField()
        view.addSubview(passwordField)
        passwordField.isSecureTextEntry.toggle()
        designTextField(target: passwordField, text: "Password", radius: radius)
        passwordField.addTarget(self, action: #selector(updatePassword), for: .editingDidBegin)
        passwordField.addTarget(self, action: #selector(donePassword), for: .editingDidEnd)

        //Login button
        loginButton = UIButton()
        view.addSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = radius
        loginButton.backgroundColor = .white
        loginButton.alpha = defaultButtonAlpha
        loginButton.addTarget(self, action: #selector(customAction), for: .touchUpInside)
        
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
            emailField.widthAnchor.constraint(equalToConstant: 325)
        ])
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalTo: emailField.widthAnchor)
        ])
    }
    
    private func designTextField(target: UITextField, text: String, radius: CGFloat){
        
        target.layer.cornerRadius = radius
        target.clipsToBounds = true
        target.placeholder = text
        target.textColor = .black
        target.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        target.backgroundColor = .systemGray3
        target.alpha = defaultTextFieldAlpha
        target.autocapitalizationType = .none
        
    }
    
    @objc
    private func updateEmail() {
        emailField.layer.masksToBounds = true
        emailField.layer.borderWidth = 2
        emailField.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc
    private func doneEmail() {
        emailField.layer.borderWidth = 0
    }
    
    @objc
    private func updatePassword() {
        passwordField.layer.masksToBounds = true
        passwordField.layer.borderWidth = 2
        passwordField.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc
    private func donePassword() {
        passwordField.layer.borderWidth = 0
        
        let password = passwordField.text
        if password != "" {
            loginButton.alpha = 1
        } else {
            loginButton.alpha = defaultButtonAlpha
        }
        
    }
    
    @objc
    private func customAction(){
        
        UIView.animate(withDuration: 0.2,
                       animations: {self.loginButton.backgroundColor = .darkGray},
                       completion: { _ in self.loginButton.backgroundColor = .white}
        )
        
        let email = emailField.text
        let password = passwordField.text
        
        let data: DataService = DataService()
        let loginStatus = data.login(email: email!, password: password!)
        
        switch loginStatus {
            case LoginStatus.success:
                print("E-mail: ", email!)
                print("Password: ", password!)
            case LoginStatus.error(_, _):
                print(loginStatus)
        }        
        
    }
    
}
