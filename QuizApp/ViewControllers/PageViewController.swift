//
//  PageViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 04.05.2021..
//

import UIKit

class PageViewController: UIPageViewController {
    
    private var quiz: Quiz
    private var numberOfQuestion: Int
    private var questionNumber: Int
    
    private var controllers: [QuizViewController] = []
    private var displayedIndex = 0
    private var correct: [Int] = []
    
    init(quiz: Quiz){
        self.quiz = quiz
        self.numberOfQuestion = quiz.questions.count
        self.questionNumber = 0
        
        for _ in 0...numberOfQuestion - 1 {
            self.correct.append(-1)
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
            controllers.append(QuizViewController(quiz: quiz, number: questionNumber, pageViewContoller: self))
        }
        
        guard let firstViewController = controllers.first else { return }
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
    }
    
    public func updateCorrect(questionNumber: Int, correct: Bool){
        if correct {
            self.correct[questionNumber] = 1
        } else {
            self.correct[questionNumber] = 0
        }
        
        if questionNumber < quiz.questions.count - 1 {
            displayedIndex = questionNumber + 1
            setViewControllers([controllers[displayedIndex]], direction: .forward, animated: true, completion: nil)
    
        }

    }
    
    public func getCorrect() -> [Int] {
        return correct

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
