//
//  PageViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 04.05.2021..
//

import UIKit

class PageViewController: UIPageViewController, QuestionAnsweredDelegate {
    
    private var quiz: Quiz
    private var numberOfQuestion: Int
    private var questionNumber: Int
    private var startTime: TimeInterval
    private var endTime: TimeInterval
    
    private var networkService = NetworkService()
    private var controllers: [QuizViewController] = []
    private var displayedIndex = 0
    private var correctArray: [Int] = []
    
    init(quiz: Quiz){
        self.quiz = quiz
        self.numberOfQuestion = quiz.questions.count
        self.questionNumber = 0
        self.startTime = Date().timeIntervalSince1970
        self.endTime = Date().timeIntervalSince1970
        
        for _ in 0...numberOfQuestion - 1 {
            self.correctArray.append(-1)
        }
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        
        let titleItem = UILabel()
        titleItem.text = "Pop Quiz"
        titleItem.textColor = .white
        titleItem.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.navigationItem.titleView = titleItem

        view.backgroundColor = Color().colorBackground
        
        let pageAppearance = UIPageControl.appearance()
        pageAppearance.currentPageIndicatorTintColor = Color().colorBackground
        pageAppearance.pageIndicatorTintColor = Color().colorBackground
        
        //dataSource = self
        
        for questionNumber in 0...numberOfQuestion - 1 {
            let quizViewController = QuizViewController(quiz: quiz, number: questionNumber, correct: correctArray)
            quizViewController.delegate = self
            controllers.append(quizViewController)
        }
        
        guard let firstViewController = controllers.first else { return }
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
    }
    
    public func updateCorrect(questionNumber: Int, correct: Bool){
        if correct {
            self.correctArray[questionNumber] = 1
        } else {
            self.correctArray[questionNumber] = 0
        }
        
        if questionNumber < quiz.questions.count - 1 {
            displayedIndex = questionNumber + 1
            controllers[displayedIndex].correct = correctArray
            setViewControllers([controllers[displayedIndex]], direction: .forward, animated: true, completion: nil)
    
        }
        
        if questionNumber == quiz.questions.count - 1 {
            endTime = Date().timeIntervalSince1970
            let time = endTime - startTime

            let finalCorrectAnswersCount = correctArray.filter{ $0 == 1 }.count
            
            //let quizResults = QuizResults(quiz_id: quiz.id, user_id: 136, time: Double(time), no_of_correct: finalCorrectAnswersCount)
            //let data = try! JSONEncoder().encode(quizResults)
            
            let parameters: [String: Any] = [
                "quiz_id": quiz.id,
                "user_id": 136,
                "time": Double(time),
                "no_of-correct": finalCorrectAnswersCount
            ]
            
            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/result") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            
            networkService.executeUrlRequest(request) { (result: Result<Login, RequestError>) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    print(value)
                }
            }
            
            let quizResultViewController = QuizResultViewController(questionNumber: quiz.questions.count, correctNumber: finalCorrectAnswersCount)
            navigationController?.setViewControllers([quizResultViewController], animated: true)
            
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        displayedIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return numberOfQuestion

    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let quizViewContorller = viewController as? QuizViewController,
            let controllerIndex = controllers.firstIndex(of: quizViewContorller),
            controllerIndex + 1 < controllers.count
        else {
            return nil
        }
        
        displayedIndex = controllerIndex + 1
        return controllers[displayedIndex]

    }
    
}
