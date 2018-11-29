//
//  CommentCell.swift
//  InstagramClone
//
//  Created by BTK Apple on 26.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    var comment:Comment?{
        didSet{
            guard let comment = self.comment else{ return }
            self.profileImageView.loadImage(with: comment.user.imageUrl)
            self.setupLabelText(with: comment, and: comment.user)
        }
    }
    
    let profileImageView:SKImageView = {
        let iv = SKImageView(withDoubleTapEnabled: false)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    let commentLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        
        addSubview(commentLabel)
        commentLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 8, paddingBottom: 6, paddingRight: 8, width: 0, height: 0)
        commentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        
        let seperator = UIView()
        seperator.backgroundColor = .seperator

        addSubview(seperator)
        seperator.anchor(top: nil, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    func setupLabelText(with comment:Comment, and user:User?){
        let attributedText = NSMutableAttributedString(string: comment.body, attributes: TextAttributes.captionAttributes)
        guard let user = user else{
            commentLabel.attributedText = attributedText
            return
        }
        attributedText.insert(NSAttributedString(string: "\(user.username) ", attributes: TextAttributes.titleAttributes), at: 0)
        commentLabel.attributedText = attributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
