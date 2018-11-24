//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 24.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post:Post?{
        didSet{
            guard let post = self.post else{ return }
            photoImageView.loadImage(with: post.imageUrl)
            usernameLabel.text = post.user.username
            profileImageView.loadImage(with: post.user.imageUrl)
            self.setAttributedText(with: post)
        }
    }
    
    func setAttributedText(with post:Post){
        let attributedText = NSMutableAttributedString(string: "\(post.user.username) ", attributes: TextAttributes.titleAttributes)
        attributedText.append(NSAttributedString(string: post.captionText, attributes: TextAttributes.captionAttributes))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: TextAttributes.gapAttributes))
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: TextAttributes.timestampAttributes))
        usernameAndCaptionLabel.attributedText = attributedText
    }
    
    let profileImageView: SKImageView = {
        let iv = SKImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    let threeDotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.tintColor = .black
        return button
    }()
    
    let photoImageView: SKImageView = {
        let iv = SKImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let favButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let usernameAndCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(threeDotButton)
        threeDotButton.anchor(top: profileImageView.topAnchor, left: nil, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 44, height: 0)
        
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: threeDotButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        let threeButtonStackView = UIStackView(arrangedSubviews: [favButton, commentButton, sendButton])
        threeButtonStackView.axis = .horizontal
        threeButtonStackView.distribution = .fillEqually
        
        addSubview(threeButtonStackView)
        threeButtonStackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: threeButtonStackView.topAnchor, left: nil, bottom: threeButtonStackView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 36, height: 0)
        
        addSubview(usernameAndCaptionLabel)
        usernameAndCaptionLabel.anchor(top: threeButtonStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
