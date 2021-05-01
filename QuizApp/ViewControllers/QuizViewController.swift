//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.04.2021..
//

import UIKit

class QuizViewController: UIViewController {
    private var questionNumber: UILabel!
    private var questionTrackerView: UIProgressView!
    private var question: UILabel!
    private var first: UIButton!
    private var second: UIButton!
    private var third: UIButton!
    private var forth: UIButton!
    
    private let dataService =  DataService()
    private let radius: CGFloat = 25
    private let alpha: CGFloat = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
    }
    
    func buildViews(){
        view.backgroundColor = Color().colorBackground
        
        questionNumber = UILabel()
        view.addSubview(questionNumber)
        questionNumber.text = "1/8"
        questionNumber.textColor = .white
        
        questionTrackerView = UIProgressView()
        view.addSubview(questionTrackerView)
        
        question = UILabel()
        view.addSubview(question)
        question.text = "question"
        question.numberOfLines = 0
        
        first = UIButton()
        view.addSubview(first)
        first.backgroundColor = .white
        first.alpha = alpha
        first.layer.cornerRadius = radius
        first.setTitle("First Answer", for: .normal)
        first.setTitleColor(Color().buttonTextColor, for: .normal)
        first.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        //first.addTarget(self, action: #selector(getQuizes), for: .touchUpInside)
        
        second = UIButton()
        view.addSubview(second)
        second.backgroundColor = .white
        second.alpha = alpha
        second.layer.cornerRadius = radius
        second.setTitle("Second Answer", for: .normal)
        second.setTitleColor(Color().buttonTextColor, for: .normal)
        second.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        //first.addTarget(self, action: #selector(getQuizes), for: .touchUpInside)
        
        third = UIButton()
        view.addSubview(third)
        third.backgroundColor = .white
        third.alpha = alpha
        third.layer.cornerRadius = radius
        third.setTitle("Third Answer", for: .normal)
        third.setTitleColor(Color().buttonTextColor, for: .normal)
        third.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        //first.addTarget(self, action: #selector(getQuizes), for: .touchUpInside)
        
        forth = UIButton()
        view.addSubview(forth)
        forth.backgroundColor = .white
        forth.alpha = alpha
        forth.layer.cornerRadius = radius
        forth.setTitle("Forth Answer", for: .normal)
        forth.setTitleColor(Color().buttonTextColor, for: .normal)
        forth.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        //first.addTarget(self, action: #selector(getQuizes), for: .touchUpInside)
        
        
    }
    
    func addConstraints(){
        questionNumber.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        questionNumber.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        questionNumber.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        questionNumber.autoSetDimension(.height, toSize: 40)

        questionTrackerView.autoPinEdge(.top, to: .bottom, of: questionNumber, withOffset: 10)
        questionTrackerView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        questionTrackerView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        questionTrackerView.autoSetDimension(.height, toSize: 60)
        
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
        forth.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 30)
        forth.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 30)
        forth.autoSetDimension(.height, toSize: 55)
        
    }
    
}
