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

    private var leadingConstraintEmail: NSLayoutConstraint!
    private var tralingConstraintEmail: NSLayoutConstraint!
    private var leadingConstraintPassword: NSLayoutConstraint!
    private var tralingConstraintPassword: NSLayoutConstraint!
    private var leadingConstraintButton: NSLayoutConstraint!
    private var tralingConstraintButton: NSLayoutConstraint!
    private var topConstraintTitleLabel: NSLayoutConstraint!
    private var topConstraintEmail: NSLayoutConstraint!
    private var topConstraintPassword: NSLayoutConstraint!
    private var topConstraintButton: NSLayoutConstraint!
    
    
    private var iconClick: Bool = true

    private let defaultTextFieldAlpha: CGFloat = 0.6
    private let defaultButtonAlpha: CGFloat = 0.8
    private let radius: CGFloat = 25
    private let duration: TimeInterval = 1.5
    
    private let networkService = QuizNetworkDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
        self.navigationController?.navigationBar.barTintColor = Color().colorBackground
        
    }
    
    private func buildViews() {
        view.backgroundColor = Color().colorBackground
        
        // ScrollView
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        scrollView.automaticallyAdjustsScrollIndicatorInsets = true

        // Title label
        titleLabel = UILabel()
        scrollView.addSubview(titleLabel)
        titleLabel.isHidden = true
        titleLabel.alpha = 1
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 45)
        
        var bounds = titleLabel.bounds
        bounds.size = titleLabel.intrinsicContentSize
        titleLabel.bounds = bounds
        let scaleX = titleLabel.frame.size.width / bounds.size.width
        let scaleY = titleLabel.frame.size.height / bounds.size.height
        titleLabel.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        // E-mail field
        emailView = UIView()
        scrollView.addSubview(emailView)
        emailView.isHidden = true
        
        emailField = UITextField()
        designTextField(viewField: emailView, textField: emailField, text: "E-mail", radius: radius)
        emailField.addTarget(self, action: #selector(updateEmail), for: .editingDidBegin)
        emailField.addTarget(self, action: #selector(doneEmail), for: .editingDidEnd)

        // Password field
        passwordView = UIView()
        passwordView.isHidden = true
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

        // Login button
        loginButton = UIButton()
        scrollView.addSubview(loginButton)
        loginButton.isHidden = true
        loginButton.isEnabled = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(Color().buttonTextColor, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        loginButton.layer.cornerRadius = radius
        loginButton.backgroundColor = .white
        loginButton.alpha = 0
        loginButton.addTarget(self, action: #selector(attemptLogin), for: .touchUpInside)
        
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
        scrollView.autoPinEdge(.top, to: .top, of: view)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: view)
        scrollView.autoPinEdge(.leading, to: .leading, of: view)
        scrollView.autoPinEdge(.trailing, to: .trailing, of: view)
        
        topConstraintTitleLabel = titleLabel.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 65)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 35)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 35)
        titleLabel.autoSetDimension(.height, toSize: 50)

        topConstraintEmail = emailView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 120)
        leadingConstraintEmail = emailView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 35)
        tralingConstraintEmail = emailView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 35)
        emailView.autoSetDimension(.height, toSize: 50)
        
        emailField.autoPinEdge(.top, to: .top, of: emailView)
        emailField.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        emailField.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        emailField.autoSetDimension(.height, toSize: 50)
        
        topConstraintPassword = passwordView.autoPinEdge(.top, to: .bottom, of: emailView, withOffset: 10)
        leadingConstraintPassword = passwordView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 35)
        tralingConstraintPassword = passwordView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 35)
        passwordView.autoSetDimension(.height, toSize: 50)
        
        passwordField.autoPinEdge(.top, to: .top, of: passwordView)
        passwordField.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        passwordField.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        passwordField.autoSetDimension(.height, toSize: 50)
        
        topConstraintButton = loginButton.autoPinEdge(.top, to: .bottom, of: passwordView, withOffset: 10)
        leadingConstraintButton = loginButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 35)
        tralingConstraintButton = loginButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 35)
        loginButton.autoSetDimension(.height, toSize: 50)
        
        hiddenErrorLabel.autoPinEdge(.top, to: .bottom, of: loginButton, withOffset: 10)
        hiddenErrorLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        hiddenErrorLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        hiddenErrorLabel.autoSetDimension(.height, toSize: 30)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        leadingConstraintEmail.constant = -view.frame.width
        tralingConstraintEmail.constant = -view.frame.width
        
        leadingConstraintPassword.constant = -view.frame.width
        tralingConstraintPassword.constant = -view.frame.width
        
        leadingConstraintButton.constant = -view.frame.width
        tralingConstraintButton.constant = -view.frame.width
        
        titleLabel.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleLabel.isHidden = false
        emailView.isHidden = false
        passwordView.isHidden = false
        loginButton.isHidden = false
        
        // Animate Title Label
        UIView.animate(withDuration: duration, animations: {
         self.titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.titleLabel.alpha = 1
        })
        
        // Animate E-mail Field
        leadingConstraintEmail.constant = 35
        tralingConstraintEmail.constant = -35
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.emailView.alpha = self.defaultTextFieldAlpha
        })
        
        // Animate Password Field
        leadingConstraintPassword.constant = 35
        tralingConstraintPassword.constant = -35
        UIView.animate(withDuration: duration, delay: 0.25, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.passwordView.alpha = self.defaultTextFieldAlpha
        })
        
        // Animate Login Button
        leadingConstraintButton.constant = 35
        tralingConstraintButton.constant = -35
        UIView.animate(withDuration: duration, delay: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.loginButton.alpha = self.defaultButtonAlpha
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        topConstraintTitleLabel.constant = -view.frame.height
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        
        //titleLabel.isHidden = true
        //emailView.isHidden = true
        //passwordView.isHidden = true
        //loginButton.isHidden = true
    }
    
    private func designTextField(viewField: UIView, textField: UITextField, text: String, radius: CGFloat){
        viewField.backgroundColor = Color().colorTextField
        viewField.layer.cornerRadius = radius
        viewField.clipsToBounds = true
        viewField.alpha = 0
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
    public func attemptLogin() {
        loginButton.isEnabled = false
        let email = emailField.text
        let password = passwordField.text
        guard let username = email, let password = password else { return }

        networkService.login(loginViewController: self, username: username, password: password)
        
        guard let reachable = networkService.reach?.isReachable() else { return }
        if !reachable {
            loginButton.isEnabled = true
            let popUpWindow = PopUpWindowController()
            self.navigationController?.present(popUpWindow, animated: true, completion: nil)
            
        }

    }
    
    private func login(success: Bool) {
        UIView.animate(withDuration: 0.2,
                       animations: { self.loginButton.backgroundColor = .darkGray },
                       completion: { _ in self.loginButton.backgroundColor = .white })
        
        if success {
            let email = emailField.text
            let password = passwordField.text
    
            guard let username = email, let password = password else { return }
            print("E-mail:  \(username)")
            print("Password: \(password)")

            let quizzesViewController = QuizzesViewController()
            quizzesViewController.tabBarItem = UITabBarItem(title: "Quiz", image:  UIImage(systemName: "stopwatch"), selectedImage: UIImage(systemName:"stopwatch.fill"))
            
            let searchQuizViewController = SearchQuizViewController()
            searchQuizViewController.tabBarItem = UITabBarItem(title: "Search", image:  UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName:"magnifyingglass.circle.fill"))
            
            let settingsViewController = SettingsViewController()
            settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image:  UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName:"gearshape.fill"))
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [quizzesViewController, searchQuizViewController, settingsViewController]
            self.navigationController?.setViewControllers([tabBarController], animated: true)
            
        } else {
            loginButton.isEnabled = true
            print("Error: Wrong password or username")
            hiddenErrorLabel.isHidden = false
            hiddenErrorLabel.text = "Error: Wrong password or username"
        
        }
    }
    
    public func loginAPIResult(result: Bool) {
        DispatchQueue.main.sync {
            login(success: result)
        }
    }
    
}
