//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Marta Grotic on 06.04.2021..
//

import Foundation
import UIKit
import PureLayout


class QuizzesViewController: UIViewController, UITableViewDelegate {
    
    private var titleLabel: UILabel!
    private var button: UIButton!
    private var funFactLabel: UILabel!
    private var infLabel: UILabel!
    private var quizzes: [Quiz]!
    private var tableView: UITableView!
    private var headerView: UIView!
    
    private let cellIdentifier = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        
    }
    
    private func buildViews() {
        
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
        
        //Fun Fact Title and adding bulb image
        funFactLabel = UILabel()
        view.addSubview(funFactLabel)
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named:"bulb")
        attachment.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        let textString = NSAttributedString(string: "Fun Fact",
                                            attributes: [.font: UIFont(name: "HelveticaNeue-Bold", size: 35)!,
                                                         .foregroundColor: UIColor.white])
        mutableAttributedString.append(textString)
        funFactLabel.attributedText = mutableAttributedString
        
        //Fun Fact Label
        infLabel = UILabel()
        view.addSubview(infLabel)
        infLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        infLabel.textColor = .white
        
    }
    
    private func addConstraints() {
        
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        titleLabel.autoSetDimension(.width, toSize: 200)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        button.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
        button.autoSetDimensions(to: CGSize(width: 200, height: 40))
        button.autoAlignAxis(toSuperviewAxis: .vertical)
        
        funFactLabel.autoPinEdge(.top, to: .bottom, of: button, withOffset: 10)
        funFactLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        funFactLabel.autoSetDimension(.height, toSize: 40)
        
    }
    
    
    @objc
    private func getQuizes(){
        
        let dataService =  DataService()
        quizzes = dataService.fetchQuizes()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 300, width: view.bounds.width, height: view.bounds.height))
        tableView.backgroundColor = .systemTeal
        tableView.separatorColor = .systemTeal
        tableView.sectionIndexColor = .white
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension QuizzesViewController: UITableViewDataSource {
    func ​​​numberOfSections​(​in​ tableView: UITableView) -> Int {
        return QuizCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .systemTeal
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        cell.alpha = 0.5
        cell.textLabel?.text = quizzes[indexPath.row].title

        return cell
    }
}
