//
//  UserProfileHeader.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user:User?{
        didSet{
            guard let userLocal = user else { return }
            usernameLabel.text = userLocal.username
            profileImageView.loadImage(with: userLocal.imageUrl)
        }
    }
    
    let profileImageView: SKImageView = {
        let iv = SKImageView()
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.1)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.1)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedText =  NSMutableAttributedString(string: "11\n", attributes: TextAttributes.titleAttributes)
        attributedText.append(NSAttributedString(string: "posts", attributes: TextAttributes.descAttributes))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedText =  NSMutableAttributedString(string: "50\n", attributes: TextAttributes.titleAttributes)
        attributedText.append(NSAttributedString(string: "followers", attributes: TextAttributes.descAttributes))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let attributedText =  NSMutableAttributedString(string: "35\n", attributes: TextAttributes.titleAttributes)
        attributedText.append(NSAttributedString(string: "following", attributes: TextAttributes.descAttributes))
        label.attributedText = attributedText
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = .black
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.seperator.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.gridButton, self.listButton, self.bookmarkButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var statsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.postsLabel, self.followersLabel, self.followingLabel])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)

        addSubview(bottomStackView)
        bottomStackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 12, width: 0, height: 20)
        
        addSubview(statsStackView)
        statsStackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)

        addSubview(editProfileButton)
        editProfileButton.anchor(top: statsStackView.bottomAnchor, left: statsStackView.leftAnchor, bottom: nil, right: statsStackView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)

        let topDivider = UIView()
        topDivider.backgroundColor = .seperator
        addSubview(topDivider)
        topDivider.anchor(top: nil, left: leftAnchor, bottom: bottomStackView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .seperator
        addSubview(bottomDivider)
        bottomDivider.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
