//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 06.04.2021..
//

import Foundation
import UIKit
import PureLayout


class QuizzesViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var button: UIButton!
    private var funFactLabel: UILabel!
    private var infLabel: UILabel!
    private var quizzes: [Quiz]!
    private var tableView: UITableView!
    private var errorView: UIView!
    private var imageErrorView: UIImageView!
    private var errorTitle: UILabel!
    private var errorText: UILabel!
    private var nba:Int!
    
    private let cellIdentifier = "cellId"
    private let headerIdentifier = "headerId"
    private let colorBackground = UIColor(red: 0.2471, green: 0.5922, blue: 0.9882, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildFirstViews()
        addFirstConstraints()
        
    }
    
    private func buildFirstViews() {
        
        view.backgroundColor = colorBackground
        
        //Title label
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "PopQuiz"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        titleLabel.textColor = .white
        
        //Get Quizes button
        button = UIButton()
        view.addSubview(button)
        button.backgroundColor = .white
        button.alpha = 0.5
        button.layer.cornerRadius = 20
        button.setTitle("Get Quiz", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.addTarget(self, action: #selector(getQuizes), for: .touchUpInside)
        
        //Error View
        errorView = UIView()
        view.addSubview(errorView)
        
        imageErrorView = UIImageView(image: UIImage(systemName: "xmark.circle"))
        imageErrorView.contentMode = .scaleToFill
        errorView.addSubview(imageErrorView)
        
        errorTitle = UILabel()
        errorTitle.text = "Error"
        errorTitle.textColor = .white
        errorTitle.textAlignment = .center
        errorTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        errorView.addSubview(errorTitle)
        
        errorText = UILabel()
        errorText.numberOfLines = 0
        errorText.textAlignment = .center
        errorText.textColor = .white
        errorText.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        errorText.text = "Data can't be reached. \n Please try again!"
        errorView.addSubview(errorText)
        
    }
    
    private func addFirstConstraints() {
        
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        titleLabel.autoSetDimension(.width, toSize: 200)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        button.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 15)
        button.autoSetDimensions(to: CGSize(width: 200, height: 40))
        button.autoAlignAxis(toSuperviewAxis: .vertical)
        
        errorView.autoSetDimensions(to: CGSize(width: view.bounds.width, height: 500))
        errorView.autoPinEdge(.top, to: .bottom, of: button, withOffset: 10)
        errorView.autoPinEdge(toSuperviewSafeArea: .leading)
        errorView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        errorTitle.autoCenterInSuperview()
        errorTitle.autoSetDimension(.width, toSize: 200)
        errorTitle.autoAlignAxis(toSuperviewAxis: .vertical)
        
        imageErrorView.autoPinEdge(.bottom, to: .top, of: errorTitle, withOffset: -10)
        imageErrorView.autoSetDimensions(to: CGSize(width: 80, height: 80))
        imageErrorView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        errorText.autoPinEdge(.top, to: .bottom, of: errorTitle, withOffset: 10)
        errorText.autoAlignAxis(toSuperviewAxis: .vertical)

    }
    
    @objc
    private func getQuizes(){
        
        errorView.isHidden = true
        
        let dataService =  DataService()
        quizzes = dataService.fetchQuizes()
        
        // Filter Quizzes for some words and count
        let questions = quizzes.flatMap{ $0.questions }
        let q = questions.filter{ $0.question.contains("NBA") }
        nba = q.count
        
        buildSecondView()
        addSecondConstraints()

        // TableView
        tableView = UITableView(frame: CGRect(x: 20, y: 280, width: view.bounds.width - 40, height: view.bounds.height))
        tableView.backgroundColor = colorBackground
        tableView.separatorColor = colorBackground
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
    private func buildSecondView(){
        
        //Fun Fact Title and adding bulb image
        funFactLabel = UILabel()
        view.addSubview(funFactLabel)
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named:"bulb")
        attachment.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        let textString = NSAttributedString(string: " Fun Fact",
                                            attributes: [.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!,
                                                         .foregroundColor: UIColor.white])
        mutableAttributedString.append(textString)
        funFactLabel.attributedText = mutableAttributedString
        
        //Fun Fact Label
        infLabel = UILabel()
        view.addSubview(infLabel)
        infLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        infLabel.textColor = .white
        infLabel.numberOfLines = 0
        infLabel.text = "There are \(nba!) questions that contain the word \"NBA\"."
        
    }
    
    private func addSecondConstraints(){
        
        funFactLabel.autoPinEdge(.top, to: .bottom, of: button, withOffset: 10)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        funFactLabel.autoSetDimension(.height, toSize: 40)
        
        infLabel.autoPinEdge(.top, to: .bottom, of: funFactLabel)
        infLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        infLabel.autoSetDimensions(to: CGSize(width: (view.frame.width - 40), height: 60))
    }
}

extension QuizzesViewController: UITableViewDataSource {
    
    func ​​​numberOfSections​(​in tableView: UITableView) -> Int {
        return QuizCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int!
        
        switch section {
        case 0:
            let science = quizzes.filter{ $0.category == QuizCategory.science }
            count = science.count
            return count
        case 1:
            let sport = quizzes.filter{ $0.category == QuizCategory.sport }
            count = sport.count
            return count
        default:
            count = 0
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor(red: 0.5804, green: 0.7725, blue: 0.9882, alpha: 1.0)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        let imageView = UIImageView(image: UIImage(named: "bulb"))
        cell.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 30)
        imageView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        imageView.autoSetDimensions(to: CGSize(width: 130, height: 130))
        
        let levelView = makeLevelView(level: quizzes[indexPath.row].level)
        cell.addSubview(levelView)
        levelView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 15)
        levelView.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 100)
        levelView.autoSetDimensions(to: CGSize(width: 75, height: 25))
        
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        title.numberOfLines = 0
        title.text = quizzes[indexPath.row].title
        cell.addSubview(title)
        title.autoPinEdge(.top, to: .bottom, of: levelView, withOffset: 10)
        title.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 10)
        title.autoPinEdge(.trailing, to: .trailing, of: levelView)
        
        let description = UILabel()
        description.textColor = .white
        description.font = UIFont(name: "HelveticaNeue", size: 18)
        description.numberOfLines = 0
        description.text = quizzes[indexPath.row].description
        cell.addSubview(description)
        description.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 10)
        description.autoPinEdge(.top, to: .bottom, of: title, withOffset: 10)
        description.autoPinEdge(.trailing, to: .trailing, of: levelView)

        print("Section: \(indexPath.section) Row: \(indexPath.row).")
       
        return cell
    }
    
    private func makeLevelView(level: Int) -> UIView{
        
        let levelView = UIView()
        let star = UIImage(systemName: "star")
        let fillStar = UIImage(systemName: "star.fill")
        let color = UIColor(red: 1, green: 0.7765, blue: 0.4863, alpha: 1.0)
        
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
            print("Bok!")
        }
        
        levelView.addSubview(starView1)
        levelView.addSubview(starView2)
        levelView.addSubview(starView3)
        
        return levelView
        
    }
}

extension QuizzesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = colorBackground
        
        let sectionTitle = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width, height: 20))
        sectionTitle.textColor = .white
        sectionTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        
        switch section {
        case 0:
            sectionTitle.text = QuizCategory.science.rawValue
        case 1:
            sectionTitle.text = QuizCategory.sport.rawValue
        default:
            sectionTitle.text = ""
        }
        
        headerView.addSubview(sectionTitle)

        return headerView
    }

    func ​tableView​(​_​ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
