//
//  SearchQuizViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 22.05.2021..
//

import UIKit

class SearchQuizViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var searchView: UIView!
    private var searchTextField: UITextField!
    private var searchButton: UIButton!
    private var tableView: UITableView!
    private var searchTextFieldView: UIView!
    
    private var quizzes: [Quiz]?
    private var category: [QuizCategory]?
    private var categoryNum: Int?
    
    private let cellIdentifier = "cellId"
    private let headerIdentifier = "headerId"
    private let quizRepository = QuizRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Color().colorBackground
        
        buildViews()
        addConstraints()
        
    }
    
    func buildViews(){
        view.backgroundColor = Color().colorBackground
        
        // ScrollView
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        // SearchBar
        searchView = UIView()
        scrollView.addSubview(searchView)
        searchView.backgroundColor = Color().colorBackground
        
        searchTextFieldView = UIView()
        searchView.addSubview(searchTextFieldView)
        searchTextFieldView.backgroundColor =  Color().colorTextField
        searchTextFieldView.layer.cornerRadius = 16
        
        searchTextField = UITextField()
        searchTextFieldView.addSubview(searchTextField)
        searchTextField.backgroundColor = Color().colorTextField.withAlphaComponent(0.2)
        searchTextField.tintColor = .black
        searchTextField.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        searchTextField.autocapitalizationType = .none
        
        searchButton = UIButton()
        searchView.addSubview(searchButton)
        searchButton.backgroundColor = Color().colorBackground
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(Color().buttonTextColor, for: .normal)
        searchButton.titleLabel?.font = UIFont(name: "HelveticaNeue-bold", size: 15)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        // TableView
        tableView = UITableView()
        scrollView.addSubview(tableView)
        tableView.backgroundColor = Color().colorBackground
        tableView.separatorColor = Color().colorBackground
        
        tableView.register(QuizViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func addConstraints(){
        scrollView.autoPinEdge(.top, to: .top, of: view)
        scrollView.autoPinEdge(.bottom, to: .bottom, of: view)
        scrollView.autoPinEdge(.leading, to: .leading, of: view)
        scrollView.autoPinEdge(.trailing, to: .trailing, of: view)
        
        searchView.autoPinEdge(.top, to: .top, of: scrollView, withOffset: 20)
        searchView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        searchView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        searchView.autoSetDimension(.height, toSize: 40)
        
        searchTextFieldView.autoPinEdge(toSuperviewSafeArea: .top)
        searchTextFieldView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        searchTextFieldView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 90)
        searchTextFieldView.autoPinEdge(toSuperviewSafeArea: .bottom)
        
        searchTextField.autoPinEdge(toSuperviewSafeArea: .top)
        searchTextField.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        searchTextField.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        searchTextField.autoPinEdge(toSuperviewSafeArea: .bottom)
        
        searchButton.autoPinEdge(toSuperviewSafeArea: .top)
        searchButton.autoPinEdge(.leading, to: .trailing, of: searchTextFieldView, withOffset: 15)
        searchButton.autoPinEdge(toSuperviewSafeArea: .trailing,  withInset: 10)
        searchButton.autoPinEdge(toSuperviewSafeArea: .bottom)
        
        tableView.autoPinEdge(.top, to: .bottom, of: searchView, withOffset: 15)
        tableView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        tableView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        tableView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -20)
        
    }
    
    @objc
    private func search() {
        guard let filterText = searchTextField.text else { return }
        quizzes = quizRepository.getFilteredQuizzes(text: filterText)
        
        guard let quizzes = quizzes else { return }
        category = Array(Set(quizzes.compactMap{ $0.category })).sorted{ $0.rawValue < $1.rawValue }

        guard let category = category else { return }
        categoryNum = category.count

        tableView.reloadData()
        
    }
    
}
    
extension SearchQuizViewController: UITableViewDataSource {
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

extension SearchQuizViewController: UITableViewDelegate {
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
