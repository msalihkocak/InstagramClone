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
    
    var isUserCurrentlyBeingFollowed = false
    
    var user:User?{
        didSet{
            guard let userLocal = user else { return }
            guard let loggedInUser = Auth.auth().currentUser else{ return }
            usernameLabel.text = userLocal.username
            profileImageView.loadImage(with: userLocal.imageUrl)
            isUserCurrentlyBeingFollowed = userLocal.followers.contains(loggedInUser.uid)
            self.setupFollowEditButton(for: userLocal)
            LabelType.allCases.forEach{self.setLabelCount(type: $0)}
        }
    }
    
    fileprivate func setupFollowEditButton(for user:User){
        guard let loggedInUser = Auth.auth().currentUser else{ return }
        if loggedInUser.uid == user.uid{
            editFollowButton.setTitle("Edit Profile", for: .normal)
            editFollowButton.layer.borderColor = UIColor.seperator.cgColor
            editFollowButton.tintColor = .black
            editFollowButton.layer.borderWidth = 1
            editFollowButton.backgroundColor = .clear
            addTargetToFollowEditButton(isLoggedInUser: true)
        }else{
            if isUserCurrentlyBeingFollowed{
                editFollowButton.setTitle("Unfollow", for: .normal)
                editFollowButton.tintColor = .black
                editFollowButton.backgroundColor = .seperator
            }else{
                editFollowButton.setTitle("Follow", for: .normal)
                editFollowButton.tintColor = .white
                editFollowButton.backgroundColor = .buttonBlue
            }
            
            editFollowButton.layer.borderColor = UIColor.clear.cgColor
            editFollowButton.layer.borderWidth = 0
            
            addTargetToFollowEditButton(isLoggedInUser: false)
        }
    }
    
    fileprivate func setLabelCount(type:LabelType){
        guard let userLocal = user else { return }
        switch type {
        case .followers:
            let attributedText =  NSMutableAttributedString(string: "\(userLocal.followers.count)\n", attributes: TextAttributes.titleAttributes)
            attributedText.append(NSAttributedString(string: "followers", attributes: TextAttributes.descAttributes))
            followersLabel.attributedText = attributedText
        case .following:
            let attributedText =  NSMutableAttributedString(string: "\(userLocal.followings.count)\n", attributes: TextAttributes.titleAttributes)
            attributedText.append(NSAttributedString(string: "following", attributes: TextAttributes.descAttributes))
            followingLabel.attributedText = attributedText
        case .posts:
            let attributedText =  NSMutableAttributedString(string: "\(userLocal.postsCount)\n", attributes: TextAttributes.titleAttributes)
            attributedText.append(NSAttributedString(string: "posts", attributes: TextAttributes.descAttributes))
            postsLabel.attributedText = attributedText
        }
        
    }
    
    fileprivate func addTargetToFollowEditButton(isLoggedInUser:Bool){
        if editFollowButton.allTargets.count == 0{
            if isLoggedInUser{
                editFollowButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
            }else{
                editFollowButton.addTarget(self, action: #selector(handleFollowUnfollow), for: .touchUpInside)
            }
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
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let editFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
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

        addSubview(editFollowButton)
        editFollowButton.anchor(top: statsStackView.bottomAnchor, left: statsStackView.leftAnchor, bottom: nil, right: statsStackView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)

        let topDivider = UIView()
        topDivider.backgroundColor = .seperator
        addSubview(topDivider)
        topDivider.anchor(top: nil, left: leftAnchor, bottom: bottomStackView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .seperator
        addSubview(bottomDivider)
        bottomDivider.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc func handleFollowUnfollow(){
        guard let userWhichProfileIsShowing = user else { return }
        guard let loggedInUser = Auth.auth().currentUser else { return }
        if isUserCurrentlyBeingFollowed{
            Service.unfollow(userWhichProfileIsShowing) {
                guard let index = userWhichProfileIsShowing.followers.firstIndex(of: loggedInUser.uid) else{ return }
                self.user?.followers.remove(at: index)
                self.setLabelCount(type: .followers)
                self.setupFollowEditButton(for: userWhichProfileIsShowing)
            }
        }else{
            Service.follow(userWhichProfileIsShowing) {
                self.user?.followers.append(loggedInUser.uid)
                self.setLabelCount(type: .followers)
                self.setupFollowEditButton(for: userWhichProfileIsShowing)
            }
        }
    }
    
    @objc func handleEditProfile(){
        print("Handling editprofile")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum LabelType: CaseIterable {
    case followers
    case following
    case posts
}
