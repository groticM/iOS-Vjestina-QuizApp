//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 30.04.2021..
//

import UIKit

class SettingsViewController: UIViewController{
    
    private var username: UILabel!
    private var name: UILabel!
    private var logOutButton: UIButton!
    
    private let radius: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
    }
    
    func buildViews(){
        view.backgroundColor = Color().colorBackground
        
        // Username title label
        username = UILabel()
        view.addSubview(username)
        username.text = "USERNAME"
        username.textColor = .white
        username.font = UIFont(name: "HelveticaNeue", size: 15)
        
        // Username label
        name = UILabel()
        view.addSubview(name)
        name.text = "Marta Grotic"
        name.textColor = .white
        name.font = UIFont(name: "HelveticaNeue-bold", size: 25)
        
        // Logout button
        logOutButton = UIButton()
        view.addSubview(logOutButton)
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.setTitleColor(Color().buttonTextColor, for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        logOutButton.layer.cornerRadius = radius
        logOutButton.backgroundColor = .white
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)

    }
    
    func addConstraints(){
        username.autoPinEdge(toSuperviewSafeArea: .top, withInset: 40)
        username.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 30)
        username.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        
        name.autoPinEdge(.top, to: .bottom, of: username, withOffset: 10)
        name.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 30)
        name.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        
        logOutButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 80)
        logOutButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 45)
        logOutButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 45)
        logOutButton.autoSetDimension(.height, toSize: 40)
        
    }
    
    @objc
    private func logOut() {
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers([loginViewController], animated: true)
        
    }
}
