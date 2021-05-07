//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.04.2021..
//

import UIKit

class QuizViewController: UIViewController {
    private var questionNumberLabel: UILabel!
    private var questionTrackerView: UIView!
    private var question: UILabel!
    private var first: UIButton!
    private var second: UIButton!
    private var third: UIButton!
    private var forth: UIButton!
    private var questionView: UIView!
    private var scrollView: UIScrollView!
    
    public var quiz: Quiz
    public var questionNumber: Int
    public var correct: Bool?
    
    private var pageViewController: PageViewController
    private var questionViews: [UIView] = []
    
    private let font = UIFont(name: "HelveticaNeue-bold", size: 20)
    private let dataService: DataService =  DataService()
    private let radius: CGFloat = 25
    private let alpha: CGFloat = 0.5

    
    init(quiz: Quiz, number: Int, pageViewContoller: PageViewController){
        self.quiz = quiz
        self.questionNumber = number
        self.pageViewController = pageViewContoller
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Color().colorBackground
    
        let tittleItem = UILabel()
        tittleItem.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        tittleItem.textColor = .white
        tittleItem.text = "Pop Quiz"
        navigationItem.titleView = tittleItem
        
        buildViews()
        addConstraints()
        
    }
    
    func buildViews(){
        view.backgroundColor = Color().colorBackground
        
        // Scroll View
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        // Question Number
        questionNumberLabel = UILabel()
        scrollView.addSubview(questionNumberLabel)
        questionNumberLabel.text = "\(questionNumber + 1)/\(quiz.questions.count)"
        questionNumberLabel.font = font
        questionNumberLabel.textColor = .white
        
        // Question Tracker
        questionTrackerView = makeProgressView()
        scrollView.addSubview(questionTrackerView)
        
        question = UILabel()
        scrollView.addSubview(question)
        question.text = quiz.questions[questionNumber].question
        question.font = font
        question.textColor = .white
        question.numberOfLines = 0
        
        first = UIButton()
        scrollView.addSubview(first)
        first.backgroundColor = .white
        first.alpha = alpha
        first.layer.cornerRadius = radius
        first.setTitle(quiz.questions[questionNumber].answers[0], for: .normal)
        first.setTitleColor(Color().buttonTextColor, for: .normal)
        first.titleLabel?.font = font
        first.addTarget(self, action: #selector(checkAnswers), for: .touchUpInside)
        
        second = UIButton()
        scrollView.addSubview(second)
        second.backgroundColor = .white
        second.alpha = alpha
        second.layer.cornerRadius = radius
        second.setTitle(quiz.questions[questionNumber].answers[1], for: .normal)
        second.setTitleColor(Color().buttonTextColor, for: .normal)
        second.titleLabel?.font = font
        second.addTarget(self, action: #selector(checkAnswers), for: .touchUpInside)
        
        third = UIButton()
        scrollView.addSubview(third)
        third.backgroundColor = .white
        third.alpha = alpha
        third.layer.cornerRadius = radius
        third.setTitle(quiz.questions[questionNumber].answers[2], for: .normal)
        third.setTitleColor(Color().buttonTextColor, for: .normal)
        third.titleLabel?.font = font
        third.addTarget(self, action: #selector(checkAnswers), for: .touchUpInside)
        
        forth = UIButton()
        scrollView.addSubview(forth)
        forth.backgroundColor = .white
        forth.alpha = alpha
        forth.layer.cornerRadius = radius
        forth.setTitle(quiz.questions[questionNumber].answers[3], for: .normal)
        forth.setTitleColor(Color().buttonTextColor, for: .normal)
        forth.titleLabel?.font = font
        forth.addTarget(self, action: #selector(checkAnswers), for: .touchUpInside)
        
    }
    
    func addConstraints(){
        scrollView.autoPinEdge(.top, to: .top, of: view)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: view)
        scrollView.autoPinEdge(.leading, to: .leading, of: view)
        scrollView.autoPinEdge(.trailing, to: .trailing, of: view)
        
        questionNumberLabel.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 90)
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        questionNumberLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        questionNumberLabel.autoSetDimension(.height, toSize: 40)

        questionTrackerView.autoPinEdge(.top, to: .bottom, of: questionNumberLabel, withOffset: 10)
        questionTrackerView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        questionTrackerView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        questionTrackerView.autoSetDimension(.height, toSize: 4)
        
        question.autoPinEdge(.top, to: .bottom, of: questionTrackerView, withOffset: 20)
        question.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        question.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        question.autoSetDimension(.height, toSize: 100)
        
        first.autoPinEdge(.top, to: .bottom, of: question, withOffset: 15)
        first.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 30)
        first.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        first.autoSetDimension(.height, toSize: 55)
        
        second.autoPinEdge(.top, to: .bottom, of: first, withOffset: 15)
        second.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 30)
        second.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        second.autoSetDimension(.height, toSize: 55)
        
        third.autoPinEdge(.top, to: .bottom, of: second, withOffset: 15)
        third.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 30)
        third.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        third.autoSetDimension(.height, toSize: 55)
        
        forth.autoPinEdge(.top, to: .bottom, of: third, withOffset: 15)
        forth.autoPinEdge(.bottom, to: .bottom, of: scrollView)
        forth.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 30)
        forth.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        forth.autoSetDimension(.height, toSize: 55)
        
    }
    
    func makeProgressView() -> UIView {
        let progressView = UIView()
        
        
        let correctAnswers = pageViewController.getCorrect()
        print(self)
        
        var numLeading: CGFloat = 0
        for number in 0...(quiz.questions.count - 1){

            let myView = UIView()
            progressView.addSubview(myView)

            if number == questionNumber{
                myView.backgroundColor = .white
            } else if correctAnswers[number] == 1{
                myView.backgroundColor = .systemGreen
            } else if correctAnswers[number] == 0 {
                myView.backgroundColor = .systemRed
            } else {
                myView.backgroundColor = .systemGray4
            }
            questionViews.append(myView)
            
            myView.autoPinEdge(toSuperviewSafeArea: .top)
            myView.autoPinEdge(toSuperviewSafeArea: .bottom)
            myView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: numLeading)
            myView.autoSetDimension(.height, toSize: 4)
            myView.autoSetDimension(.width, toSize: 35)
            
            numLeading += 45
                
        }
        
        return progressView
        
    }
    
    @objc
    private func checkAnswers(button: UIButton){
        let correctAnswer = quiz.questions[questionNumber].correctAnswer
        
        first.isEnabled = false
        second.isEnabled = false
        third.isEnabled = false
        forth.isEnabled = false
        
        if button.titleLabel?.text == quiz.questions[questionNumber].answers[correctAnswer]{
            button.backgroundColor = .systemGreen
            questionViews[questionNumber].backgroundColor = .systemGreen
            
            correct = true
            pageViewController.updateCorrect(questionNumber: questionNumber, correct: correct!)
            
        } else {
            button.backgroundColor = .systemRed
            questionViews[questionNumber].backgroundColor = .systemRed
            
            correct = false
            pageViewController.updateCorrect(questionNumber: questionNumber, correct: correct!)
            
            
            if first.titleLabel?.text == quiz.questions[questionNumber].answers[correctAnswer] {
                first.backgroundColor = .systemGreen
            } else if second.titleLabel?.text == quiz.questions[questionNumber].answers[correctAnswer] {
                second.backgroundColor = .systemGreen
            } else if third.titleLabel?.text == quiz.questions[questionNumber].answers[correctAnswer] {
                third.backgroundColor = .systemGreen
            } else {
                forth.backgroundColor = .systemGreen
            }
            
        }
        
        if questionNumber == quiz.questions.count - 1 {
            let finalCorrectAnswers = pageViewController.getCorrect()
            let finalCorrectAnswersCount = finalCorrectAnswers.filter{ $0 == 1 }.count
            
            let quizResultViewController = QuizResultViewController(questionNumber: quiz.questions.count, correctNumber: finalCorrectAnswersCount)
            let newNavigationController = UINavigationController(rootViewController: quizResultViewController)
            newNavigationController.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(newNavigationController, animated: true)
            
        }
        


    }
    
}
