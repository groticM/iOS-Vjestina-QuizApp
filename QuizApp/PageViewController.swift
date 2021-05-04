//
//  PageViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 04.05.2021..
//

import UIKit

class PageViewController: UIPageViewController {
    
    private var numberOfQuestion: Int?
    private var quiz: Quiz
    private var controllers: [QuizViewController] = []
    private var displayedIndex = 0
    
    init(quiz: Quiz){
        self.quiz = quiz
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color().colorBackground
        
        let numberOfQuestion = quiz.questions.count
        
        for questionNumber in 0...numberOfQuestion {
            controllers.append(QuizViewController(quiz: quiz, number: questionNumber, correct: 0))
        }

        guard let firstVC = controllers.first else { return }

        //postavljanje boje indikatora stranice
        let pageAppearance = UIPageControl.appearance()
        pageAppearance.currentPageIndicatorTintColor = .black
        pageAppearance.pageIndicatorTintColor = .lightGray

        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }

}

extension PageViewController: UIPageViewControllerDataSource {

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        displayedIndex
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return numberOfQuestion!

    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let quizzesViewContorller = QuizzesViewController()
        return quizzesViewContorller
        
    }

    //Navigacija u naprijed
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return controllers[displayedIndex+1]

    }
}
