//
//  QuizCell.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.04.2021..
//

import UIKit

class QuizViewCell: UITableViewCell {
    
    var quizImage: UIImageView!
    var titleLabel: UILabel!
    var quizDescription: UILabel!
    var levelView: UIView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Image
        quizImage = UIImageView(image: UIImage(named: "bulb"))
        quizImage.contentMode = .scaleToFill
        
        // Title of the quiz
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        titleLabel.numberOfLines = 0

        // Description of the quiz
        quizDescription = UILabel()
        quizDescription.textColor = .white
        quizDescription.font = UIFont(name: "HelveticaNeue", size: 18)
        quizDescription.numberOfLines = 0
        
        // Level
        levelView = UIView()
        
        contentView.addSubview(quizImage)
        contentView.addSubview(levelView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(quizDescription)
                
        quizImage.autoPinEdge(toSuperviewSafeArea: .top, withInset: 30)
        quizImage.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        quizImage.autoSetDimensions(to: CGSize(width: 120, height: 120))
        
        levelView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 15)
        levelView.autoPinEdge(.leading, to: .trailing, of: quizImage, withOffset: 120)
        levelView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        levelView.autoSetDimension(.height, toSize: 25)
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: levelView, withOffset: 5)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: quizImage, withOffset: 5)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        titleLabel.autoSetDimension(.height, toSize: 45)
        
        quizDescription.autoPinEdge(.top, to: .bottom, of: titleLabel)
        quizDescription.autoPinEdge(.leading, to: .trailing, of: quizImage, withOffset: 5)
        quizDescription.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        quizDescription.autoSetDimension(.height, toSize: 75)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
