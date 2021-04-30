//
//  QuizCell.swift
//  QuizApp
//
//  Created by Marta Grotic on 27.04.2021..
//

import UIKit

class QuizCell: UITableViewCell {
    /*private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var description: UILabel!
    private var levelView: UIView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectedView = UIView()
        selectedView.backgroundColor = .systemTeal
        //cell.selectedBackgroundView = selectedView
        
        // Image
        imageView = UIImageView(image: UIImage(named: "bulb"))
        //cell.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        
        // Title of the quiz
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        titleLabel.numberOfLines = 0
        //cell.addSubview(title)

        // Description of the quiz
        description = UILabel()
        description.textColor = .white
        description.font = UIFont(name: "HelveticaNeue", size: 18)
        description.numberOfLines = 0
        //cell.addSubview(description)
        
        // Level
        levelView = UIView()
                
        imageView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 30)
        imageView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        imageView.autoSetDimensions(to: CGSize(width: 120, height: 120))
        
        levelView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 15)
        levelView.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 125)
        levelView.autoSetDimensions(to: CGSize(width: 75, height: 25))
        
        titleLabel.autoPinEdge(.top, to: .bottom, of: levelView, withOffset: 10)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 10)
        titleLabel.autoSetDimensions(to: CGSize(width: 200, height: 45))
        
        description.autoPinEdge(.leading, to: .trailing, of: imageView, withOffset: 10)
        description.autoPinEdge(.top, to: .bottom, of: titleLabel)
        description.autoSetDimensions(to: CGSize(width: 200, height: 75))
        
    }*/
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
