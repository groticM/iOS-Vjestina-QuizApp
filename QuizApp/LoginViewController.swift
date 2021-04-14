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
    private var passwordButton: UIButton!
    private var iconClick: Bool = true
    private var emailView: UIView!
    private var passwordView: UIView!
    private var hiddenErrorLabel: UILabel!
    
    private let defaultTextFieldAlpha: CGFloat = 0.3
    private let defaultButtonAlpha: CGFloat = 0.5
    private let colorBackground = UIColor(red: 0.2471, green: 0.5922, blue: 0.9882, alpha: 1.0)
    private let colorTextField = UIColor(red: 0.8118, green: 0.8941, blue: 0.9882, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
    }
    
    private func buildViews() {
        let radius: CGFloat = 25
        
        view.backgroundColor = colorBackground
        
        //Title label
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        titleLabel.textColor = .white
        
        //E-mail field
        emailView = UIView()
        emailField = UITextField()
        view.addSubview(emailView)
        designTextField(viewField: emailView, textField: emailField, text: "E-mail", radius: radius)
        emailField.addTarget(self, action: #selector(updateEmail), for: .editingDidBegin)
        emailField.addTarget(self, action: #selector(doneEmail), for: .editingDidEnd)
        emailField.bounds.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        
        //Password field
        passwordView = UIView()
        passwordField = UITextField()
        view.addSubview(passwordView)
        passwordField.isSecureTextEntry.toggle()
        designTextField(viewField: passwordView, textField: passwordField, text: "Password", radius: radius)
        passwordField.addTarget(self, action: #selector(updatePassword), for: .editingDidBegin)
        passwordField.addTarget(self, action: #selector(startPassword), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(donePassword), for: .editingDidEnd)
        
        passwordButton = UIButton();
        passwordButton.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        passwordButton.tintColor = .black
        passwordButton.addTarget(self, action: #selector(seePassword), for: .touchUpInside)
        passwordField.rightViewMode = .always
        passwordField.rightView = passwordButton

        //Login button
        loginButton = UIButton()
        view.addSubview(loginButton)
        loginButton.isEnabled = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = radius
        loginButton.backgroundColor = .white
        loginButton.alpha = defaultButtonAlpha
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        // Error label
        hiddenErrorLabel = UILabel()
        view.addSubview(hiddenErrorLabel)
        hiddenErrorLabel.isHidden = true
        hiddenErrorLabel.backgroundColor = colorBackground
        hiddenErrorLabel.layer.cornerRadius = radius
        hiddenErrorLabel.clipsToBounds = true
        hiddenErrorLabel.textAlignment = .center
        hiddenErrorLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        
    }
    
    private func addConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.widthAnchor.constraint(equalToConstant: 220)
        ])
        
        emailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            emailView.heightAnchor.constraint(equalToConstant: 50),
            emailView.widthAnchor.constraint(equalToConstant: 325)
        ])
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: emailView.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: emailView.topAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            emailField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 10),
            passwordView.heightAnchor.constraint(equalToConstant: 50),
            passwordView.widthAnchor.constraint(equalTo: emailView.widthAnchor)
        ])
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: passwordView.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: passwordView.topAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 10),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalTo: emailView.widthAnchor)
        ])
        
        hiddenErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hiddenErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hiddenErrorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            hiddenErrorLabel.heightAnchor.constraint(equalToConstant: 30),
            hiddenErrorLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func designTextField(viewField: UIView,textField: UITextField, text: String, radius: CGFloat){
        
        viewField.layer.cornerRadius = radius
        viewField.clipsToBounds = true
        viewField.backgroundColor = colorTextField
        viewField.alpha = defaultTextFieldAlpha
        
        textField.placeholder = text
        textField.tintColor = .black
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        textField.backgroundColor = colorTextField
        textField.autocapitalizationType = .none
        
        viewField.addSubview(textField)
        
    }
    
    @objc
    private func updateEmail() {
        hiddenErrorLabel.isHidden = true
        emailView.layer.masksToBounds = true
        emailView.layer.borderWidth = 2
        emailView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc
    private func doneEmail() {
        emailView.layer.borderWidth = 0
    }
    
    @objc
    private func updatePassword() {
        hiddenErrorLabel.isHidden = true
        passwordView.layer.masksToBounds = true
        passwordView.layer.borderWidth = 2
        passwordView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc
    private func startPassword() {
        hiddenErrorLabel.isHidden = true
        
        let password = passwordField.text
        if password != "" {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.alpha = defaultButtonAlpha
        }
    }
    
    @objc
    private func donePassword() {
        passwordView.layer.borderWidth = 0
    }
    
    @objc
    private func seePassword() {
        if(iconClick == true) {
            passwordButton.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordField.isSecureTextEntry = false
        } else {
            passwordButton.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
            passwordField.isSecureTextEntry  = true
        }

        iconClick = !iconClick
        
    }
    
    @objc
    private func login(){
        
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
            case LoginStatus.error(let code, let text):
                print("Error: \(text) (\(code))")
                hiddenErrorLabel.isHidden = false
                hiddenErrorLabel.text = "Error: \(text) (\(code))"
        }
    }
}
