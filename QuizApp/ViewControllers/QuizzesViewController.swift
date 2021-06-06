//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 06.04.2021..
//

import UIKit
import PureLayout

class QuizzesViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var funFactLabel: UILabel!
    private var infLabel: UILabel!
    private var tableView: UITableView!
    private var errorView: UIView!
    private var imageErrorView: UIImageView!
    private var errorTitle: UILabel!
    private var errorText: UILabel!
    private var scrollView: UIScrollView!
    private var funFactView: UIView!
    private var imageBulbView: UIImageView!
    
    private var quizzes: [Quiz]?
    private var nba: Int?
    private var category: [QuizCategory]?
    private var categoryNum: Int?
    
    private let quizRepository = QuizRepository()
    private let cellIdentifier = "cellId"
    private let headerIdentifier = "headerId"
    private let controllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Color().colorBackground
        
        buildViews()
        addConstraints()
        
    }
    
    private func buildViews() {
        view.backgroundColor = Color().colorBackground
        
        // ScrollView
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        // Title label
        titleLabel = UILabel()
        scrollView.addSubview(titleLabel)
        titleLabel.isHidden = false
        titleLabel.text = "PopQuiz"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        initiateGettingQuizzes()

        imageErrorView = UIImageView(image: UIImage(systemName: "xmark.circle"))
        scrollView.addSubview(imageErrorView)
        imageErrorView.isHidden = false
        imageErrorView.contentMode = .scaleToFill

        errorTitle = UILabel()
        scrollView.addSubview(errorTitle)
        errorTitle.isHidden = false
        errorTitle.text = "Error"
        errorTitle.textColor = .white
        errorTitle.textAlignment = .center
        errorTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 35)

        errorText = UILabel()
        scrollView.addSubview(errorText)
        errorText.isHidden = false
        errorText.numberOfLines = 0
        errorText.textAlignment = .center
        errorText.textColor = .white
        errorText.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        errorText.text = "Data can't be reached. \n Please try again!"

        // Fun Fact Title and Bulb Image
        funFactView = UIView()
        scrollView.addSubview(funFactView)
        funFactView.isHidden = true
        
        imageBulbView = UIImageView(image: UIImage(named:"bulb"))
        funFactView.addSubview(imageBulbView)
        imageBulbView.isHidden = true

        funFactLabel = UILabel()
        funFactView.addSubview(funFactLabel)
        funFactLabel.text = " Fun Fact"
        funFactLabel.textColor = .white
        funFactLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        
        // Fun Fact Label
        infLabel = UILabel()
        scrollView.addSubview(infLabel)
        infLabel.isHidden = true
        infLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        infLabel.textColor = .white
        infLabel.numberOfLines = 0
        
        // TableView
        tableView = UITableView()
        scrollView.addSubview(tableView)
        tableView.isHidden = true
        tableView.backgroundColor = Color().colorBackground
        tableView.separatorColor = Color().colorBackground

        tableView.register(QuizViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func addConstraints() {
        scrollView.autoPinEdge(.top, to: .top, of: view)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: view)
        scrollView.autoPinEdge(.leading, to: .leading, of: view)
        scrollView.autoPinEdge(.trailing, to: .trailing, of: view)
        
        titleLabel.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 20)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        titleLabel.autoSetDimension(.height, toSize: 30)
        
        imageErrorView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 100)
        imageErrorView.autoSetDimensions(to: CGSize(width: 80, height: 80))
        imageErrorView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        errorTitle.autoPinEdge(.top, to: .bottom, of: imageErrorView, withOffset: 20)
        errorTitle.autoSetDimension(.width, toSize: 200)
        errorTitle.autoAlignAxis(toSuperviewAxis: .vertical)
    
        errorText.autoPinEdge(.top, to: .bottom, of: errorTitle, withOffset: 20)
        errorText.autoPinEdge(.bottom, to: .bottom, of: scrollView, withOffset: -10)
        errorText.autoAlignAxis(toSuperviewAxis: .vertical)
        
        funFactView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
        funFactView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        funFactView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        funFactView.autoSetDimension(.height, toSize: 40)
        
        imageBulbView.autoPinEdge(.top, to: .top, of: funFactView)
        imageBulbView.autoPinEdge(.leading, to: .leading, of: funFactView)
        imageBulbView.autoPinEdge(.bottom, to: .bottom, of: funFactView)
        imageBulbView.autoSetDimension(.width, toSize: 40)
        
        funFactLabel.autoPinEdge(.top, to: .top, of: funFactView)
        funFactLabel.autoPinEdge(.leading, to: .trailing, of: imageBulbView)
        funFactLabel.autoPinEdge(.bottom, to: .bottom, of: funFactView)
        funFactLabel.autoPinEdge(.trailing, to: .trailing, of: funFactView, withOffset: -20)
        
        infLabel.autoPinEdge(.top, to: .bottom, of: funFactLabel, withOffset: 5)
        infLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        infLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        infLabel.autoSetDimension(.height, toSize: 60)
        
        tableView.autoPinEdge(.top, to: .bottom, of: infLabel, withOffset: 20)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -20)
        tableView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        tableView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)

    }
    @objc
    public func initiateGettingQuizzes(){
        quizRepository.quizzesViewController = self
        quizRepository.getQuizzes()
        
    }
    
    public func getQuizes(quizzes:[Quiz]){
        
        let quizzes = quizzes.sorted{ $0.category.rawValue < $1.category.rawValue }.sorted{ $0.title < $1.title }
        
        if quizzes.isEmpty {
            let popUpWindow = PopUpWindowController()
            self.navigationController?.present(popUpWindow, animated: true, completion: nil)
            
        } else {
            self.quizzes = quizzes
            imageErrorView.isHidden = true
            errorTitle.isHidden = true
            errorText.isHidden = true
            funFactView.isHidden = false
            imageBulbView.isHidden = false
            infLabel.isHidden = false
            tableView.isHidden = false
            tableView.isHidden = false
            
            // Filter Quizzes for some words and count
            let questions = quizzes.flatMap{ $0.questions }
            let q = questions.filter{ $0.question.contains("NBA") }
            nba = q.count
                
            // Sections
            category = Array(Set(quizzes.compactMap{ $0.category })).sorted{ $0.rawValue < $1.rawValue }

            if nba != nil {
                infLabel.text = "There are \(nba!) questions that contain the word \"NBA\"."
            }
                
            guard let category = category else { return }
            categoryNum = category.count

            tableView.reloadData()
                
        }
    }
}

extension QuizzesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if categoryNum != nil {
            return categoryNum!
        } else {
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int!
        guard let quizzes = quizzes else { return 0 }
        let quizCategory = quizzes.compactMap{ $0.category }
        
        count = quizCategory.filter{ $0.rawValue == category![section].rawValue}.count

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QuizViewCell
        cell.backgroundColor = UIColor(red: 0.5804, green: 0.7725, blue: 0.9882, alpha: 1.0)
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.layer.borderWidth = 5
        cell.layer.borderColor = Color().colorBackground.cgColor
        
        let num = indexPath.section + indexPath.row
        
        if quizzes != nil {
            cell.levelView = makeLevelView(level: quizzes![num].level, levelView: cell.levelView)
            cell.titleLabel.text = quizzes![num].title
            cell.quizDescription.text = quizzes![num].description
        }

        return cell
    }
    
    private func makeLevelView(level: Int, levelView: UIView) -> UIView {
        
        let star = UIImage(systemName: "star")
        let fillStar = UIImage(systemName: "star.fill")
        let color = Color().starColor
        
        let starView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        starView1.tintColor = color
        let starView2 = UIImageView(frame: CGRect(x: 25, y: 0, width: 25, height: 25))
        starView2.tintColor = color
        let starView3 = UIImageView(frame: CGRect(x: 50, y: 0, width: 25, height: 25))
        starView3.tintColor = color

        switch level {
        case 1:
            starView1.image = fillStar
            starView2.image = star
            starView3.image = star
        case 2:
            starView1.image = fillStar
            starView2.image = fillStar
            starView3.image = star
        case 3:
            starView1.image = fillStar
            starView2.image = fillStar
            starView3.image = fillStar
        default:
            print("Error!")
        }
        
        levelView.addSubview(starView1)
        levelView.addSubview(starView2)
        levelView.addSubview(starView3)
        
        return levelView
        
    }
}

extension QuizzesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
        
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = Color().colorBackground
        
        let sectionTitle = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.bounds.size.width, height: 20))
        sectionTitle.textColor = .white
        sectionTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        
        if category != nil {
            sectionTitle.text = category![section].rawValue
        }

        headerView.addSubview(sectionTitle)

        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageViewController = PageViewController(quiz: quizzes![indexPath.section + indexPath.row])
        self.navigationController?.pushViewController(pageViewController, animated: true)

    }
    
}
