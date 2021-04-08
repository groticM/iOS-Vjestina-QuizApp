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
    
    private let cellIdentifier = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildFirstViews()
        addFirstConstraints()
        
    }
    
    private func buildFirstViews() {
        
        view.backgroundColor = .systemTeal
        
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
        
        //UIView
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
        
        button.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
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
        
        buildSecondView()
        addSecondConstraints()

        // TableView
        tableView = UITableView(frame: CGRect(x: 20, y: 300, width: view.frame.width - 40, height: view.bounds.height))
        tableView.backgroundColor = .systemTeal
        tableView.separatorColor = .systemTeal
        tableView.sectionIndexColor = .white
        tableView.rowHeight = 200
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        infLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        infLabel.textColor = .white
        infLabel.text = "fkgjnlksd fjgijsdf igjhisrtj ghiojrtioh"
        
    }
    
    private func addSecondConstraints(){
        
        funFactLabel.autoPinEdge(.top, to: .bottom, of: button, withOffset: 10)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        funFactLabel.autoSetDimension(.height, toSize: 40)
        
        infLabel.autoPinEdge(.top, to: .bottom, of: funFactLabel, withOffset: 10)
        infLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        infLabel.autoSetDimensions(to: CGSize(width: (view.frame.width - 40), height: 100))
    }
}

extension QuizzesViewController: UITableViewDataSource {
    func ​​​numberOfSections​(​in​ tableView: UITableView) -> Int {
        return QuizCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let explanationLabel = UILabel(frame: CGRect(x: -10, y: 10, width: view.frame.size.width - 20, height: 80))
        explanationLabel.textColor = UIColor.darkGray
        explanationLabel.numberOfLines = 0
        explanationLabel.text = "AA"
        
        headerView.addSubview(explanationLabel)
        headerView.backgroundColor = UIColor.clear
        return headerView
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellView = UIView()
        cellView.backgroundColor = .gray
        cellView.layer.cornerRadius = 20
        
        let imageView = UIImageView(image: UIImage(named: "bulb"))
        imageView.contentMode = .scaleToFill
        cellView.addSubview(imageView)
        imageView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 30)
        imageView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        imageView.autoSetDimensions(to: CGSize(width: 120, height: 120))
        
        let title = UILabel()
        title.text = quizzes[indexPath.row].title
        title.textColor = .white
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        title.numberOfLines = 0
        cellView.addSubview(title)
        title.autoPinEdge(toSuperviewSafeArea: .top, withInset: 30)
        title.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 10)
        title.autoSetDimension(.width, toSize: 200)
        
        let description = UILabel()
        description.text = quizzes[indexPath.row].description
        description.textColor = .white
        description.font = UIFont(name: "HelveticaNeue", size: 20)
        description.numberOfLines = 0
        cellView.addSubview(description)
        description.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 10)
        description.autoPinEdge(.top, to: .bottom, of: title, withOffset: 10)
        description.autoSetDimension(.width, toSize: 200)
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .systemTeal
        cell.addSubview(cellView)
        cell.backgroundColor = UIColor.systemTeal
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true

        return cell
    }
}

extension QuizzesViewController: UITableViewDelegate {

    func ​tableView​(​_​ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
    }
    
}
