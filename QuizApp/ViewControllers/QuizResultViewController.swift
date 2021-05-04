//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 30.04.2021..
//

import UIKit

class QuizResultViewController: UIViewController{
    
    private var correctAnswers: UILabel!
    private var finishQuiz: UIButton!
    
    private var questionNumber: Int
    private var correct: Int
    
    private let radius: CGFloat = 20
    
    init(correct: Int, questionNumber: Int){
        self.correct = correct
        self.questionNumber = questionNumber
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
    }
    
    func buildViews(){
        view.backgroundColor = Color().colorBackground
        
        // Correct answers label
        correctAnswers = UILabel()
        view.addSubview(correctAnswers)
        correctAnswers.text = "\(correct)/\(questionNumber+1)"
        correctAnswers.textColor = .white
        correctAnswers.font = UIFont(name: "HelveticaNeue", size: 130)
        
        // Finish quiz button
        finishQuiz = UIButton()
        view.addSubview(finishQuiz)
        finishQuiz.setTitle("Finish Quiz", for: .normal)
        finishQuiz.setTitleColor( Color().buttonTextColor, for: .normal)
        finishQuiz.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        finishQuiz.layer.cornerRadius = radius
        finishQuiz.backgroundColor = .white
        finishQuiz.addTarget(self, action: #selector(finish), for: .touchUpInside)

    }
    
    func addConstraints(){
        correctAnswers.autoCenterInSuperview()
        correctAnswers.autoSetDimension(.height, toSize: 100)
        
        finishQuiz.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        finishQuiz.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 45)
        finishQuiz.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 45)
        finishQuiz.autoSetDimension(.height, toSize: 40)
        
    }
    
    @objc
    private func finish(){
        let quizzesViewController = QuizzesViewController()
        
        let newNavigationController = UINavigationController(rootViewController: quizzesViewController)
        newNavigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(newNavigationController, animated: true, completion: nil)
        
    }
}

