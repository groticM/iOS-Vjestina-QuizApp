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
    private var button: UIButton!
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
    
    private var quizzes: [Quiz]!
    private var nba: Int?
    private var category: [QuizCategory]?
    private var categoryNum: Int?
    
    private let dataService =  DataService()
    private let cellIdentifier = "cellId"
    private let headerIdentifier = "headerId"
    private let controllers: [UIViewController] = [
        
    ]
    
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
        
        // Title label
        titleLabel = UILabel()
        scrollView.addSubview(titleLabel)
        titleLabel.isHidden = false
        titleLabel.text = "PopQuiz"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        // Get Quizes Button
        button = UIButton()
        scrollView.addSubview(button)
        button.isHidden = false
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 20
        button.setTitle("Get Quiz", for: .normal)
        button.setTitleColor(Color().buttonTextColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 20)
        button.addTarget(self, action: #selector(getQuizes), for: .touchUpInside)
        
        // Error View
        errorView = UIView()
        scrollView.addSubview(errorView)
        errorView.isHidden = false

        imageErrorView = UIImageView(image: UIImage(systemName: "xmark.circle"))
        errorView.addSubview(imageErrorView)
        imageErrorView.contentMode = .scaleToFill

        errorTitle = UILabel()
        errorView.addSubview(errorTitle)
        errorTitle.text = "Error"
        errorTitle.textColor = .white
        errorTitle.textAlignment = .center
        errorTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 35)

        errorText = UILabel()
        errorView.addSubview(errorText)
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
        
        funFactLabel = UILabel()
        funFactView.addSubview(funFactLabel)
        funFactLabel.text = " Fun Fact"
        funFactLabel.textColor = .white
        funFactLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        
        // Fun Fact Label
        infLabel = UILabel()
        infLabel.isHidden = true
        infLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        infLabel.textColor = .white
        infLabel.numberOfLines = 0
        scrollView.addSubview(infLabel)
        
        // TableView
        tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = Color().colorBackground
        tableView.separatorColor = Color().colorBackground
        scrollView.addSubview(tableView)
        
        tableView.register(QuizViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func addConstraints() {
        scrollView.autoPinEdge(.top, to: .top, of: view, withOffset: 5)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: 5)
        scrollView.autoPinEdge(.leading, to: .leading, of: view, withOffset: 5)
        scrollView.autoPinEdge(.trailing, to: .trailing, of: view, withOffset: 5)
        
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)

        button.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 15)
        button.autoSetDimensions(to: CGSize(width: 200, height: 40))
        button.autoAlignAxis(toSuperviewAxis: .vertical)
        
        errorView.autoPinEdge(.top, to: .bottom, of: button, withOffset: 10)
        errorView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: 30)
        errorView.autoPinEdge(toSuperviewSafeArea: .leading)
        errorView.autoAlignAxis(toSuperviewAxis: .vertical)
    
        errorText.autoCenterInSuperview()
        errorText.autoPinEdge(.top, to: .bottom, of: errorTitle, withOffset: 10)
        errorText.autoAlignAxis(toSuperviewAxis: .vertical)
        
        errorTitle.autoPinEdge(.bottom, to: .top, of: errorText, withOffset: -10)
        errorTitle.autoSetDimension(.width, toSize: 200)
        errorTitle.autoAlignAxis(toSuperviewAxis: .vertical)
        
        imageErrorView.autoPinEdge(.bottom, to: .top, of: errorTitle, withOffset: -10)
        imageErrorView.autoSetDimensions(to: CGSize(width: 80, height: 80))
        imageErrorView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        funFactView.autoPinEdge(.top, to: .bottom, of: button, withOffset: 10)
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
        tableView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: 30)
        tableView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        tableView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)

    }
    
    @objc
    private func getQuizes(){
        quizzes = dataService.fetchQuizes().sorted{ $0.category.rawValue < $1.category.rawValue }.sorted{ $0.title < $1.title }
        
        if quizzes != nil {
            errorView.isHidden = true
            funFactView.isHidden = false
            infLabel.isHidden = false
            tableView.isHidden = false
            tableView.isHidden = false
            
            // Filter Quizzes for some words and count
            let questions = quizzes.flatMap{ $0.questions }
            let q = questions.filter{ $0.question.contains("NBA") }
            nba = q.count
            
            if nba != nil {
                infLabel.text = "There are \(nba!) questions that contain the word \"NBA\"."
            }
            
            // Sections
            category = Array(Set(quizzes.compactMap{ $0.category })).sorted{ $0.rawValue < $1.rawValue }
            categoryNum = category!.count
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
        
        sectionTitle.text = category![section].rawValue

        headerView.addSubview(sectionTitle)

        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageViewController = PageViewController(quiz: quizzes![indexPath.section + indexPath.row])
        self.navigationController?.pushViewController(pageViewController, animated: true)

    }
    
}
