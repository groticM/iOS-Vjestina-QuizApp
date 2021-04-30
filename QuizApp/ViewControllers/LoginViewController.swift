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
    private var emailView: UIView!
    private var passwordView: UIView!
    private var hiddenErrorLabel: UILabel!
    private var scrollView: UIScrollView!
    
    private var iconClick: Bool = true
    
    private let defaultTextFieldAlpha: CGFloat = 0.4
    private let defaultButtonAlpha: CGFloat = 0.5
    private let radius: CGFloat = 25
    
    private let data: DataService = DataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
        self.navigationController?.navigationBar.barTintColor = Color().colorBackground
        
    }
    
    private func buildViews() {
        view.backgroundColor = Color().colorBackground
        
        //ScrollView
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        scrollView.automaticallyAdjustsScrollIndicatorInsets = true

        //Title label
        titleLabel = UILabel()
        scrollView.addSubview(titleLabel)
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        titleLabel.textColor = .white
        
        //E-mail field
        emailView = UIView()
        scrollView.addSubview(emailView)
        emailField = UITextField()
        designTextField(viewField: emailView, textField: emailField, text: "E-mail", radius: radius)
        emailField.addTarget(self, action: #selector(updateEmail), for: .editingDidBegin)
        emailField.addTarget(self, action: #selector(doneEmail), for: .editingDidEnd)

        //Password field
        passwordView = UIView()
        scrollView.addSubview(passwordView)
        passwordField = UITextField()
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
        scrollView.addSubview(loginButton)
        loginButton.isEnabled = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(Color().buttonTextColor, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        loginButton.layer.cornerRadius = radius
        loginButton.backgroundColor = .white
        loginButton.alpha = defaultButtonAlpha
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        // Error label
        hiddenErrorLabel = UILabel()
        scrollView.addSubview(hiddenErrorLabel)
        hiddenErrorLabel.isHidden = true
        hiddenErrorLabel.backgroundColor = Color().colorBackground
        hiddenErrorLabel.layer.cornerRadius = radius
        hiddenErrorLabel.clipsToBounds = true
        hiddenErrorLabel.textAlignment = .center
        hiddenErrorLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
    }
    
    private func addConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 35),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -35),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        emailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emailView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 130),
            emailView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 35),
            emailView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -35),
            emailView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: emailView.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: emailView.topAnchor),
            emailField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor, constant: 10),
            emailField.trailingAnchor.constraint(equalTo: emailView.trailingAnchor, constant: -10),
            emailField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 10),
            passwordView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 35),
            passwordView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -35),
            passwordView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: passwordView.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: passwordView.topAnchor),
            passwordField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: -10),
            passwordField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 35),
            loginButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -35),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        hiddenErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hiddenErrorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hiddenErrorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            hiddenErrorLabel.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor, constant: 50),
            hiddenErrorLabel.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: -50),
            hiddenErrorLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func designTextField(viewField: UIView,textField: UITextField, text: String, radius: CGFloat){
        viewField.backgroundColor = Color().colorTextField
        viewField.layer.cornerRadius = radius
        viewField.clipsToBounds = true
        viewField.alpha = defaultTextFieldAlpha
        viewField.addSubview(textField)
        
        textField.backgroundColor = Color().colorTextField
        textField.placeholder = text
        textField.tintColor = .black
        textField.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        textField.autocapitalizationType = .none
        
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
        if passwordField.isSecureTextEntry{
            passwordButton.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passwordButton.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        }
        passwordField.isSecureTextEntry.toggle()
        
    }
    
    @objc
    private func login(){
        UIView.animate(withDuration: 0.2,
                       animations: { self.loginButton.backgroundColor = .darkGray },
                       completion: { _ in self.loginButton.backgroundColor = .white })
        
        let email = emailField.text
        let password = passwordField.text
        
        let loginStatus = data.login(email: email!, password: password!)
        
        switch loginStatus {
            case LoginStatus.success:
                print("E-mail: ", email!)
                print("Password: ", password!)
                
                let quizzesViewController = QuizzesViewController()
                quizzesViewController.modalPresentationStyle = .overFullScreen
                present(quizzesViewController, animated: true, completion: nil)
                
            case LoginStatus.error(let code, let text):
                print("Error: \(text) (\(code))")
                hiddenErrorLabel.isHidden = false
                hiddenErrorLabel.text = "Error: \(text) (\(code))"
                
        }
    }
}
