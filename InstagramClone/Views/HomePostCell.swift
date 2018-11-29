//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 24.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(of post:Post)
    func didLikePost(at cell: HomePostCell, forceLike:Bool)
}

class HomePostCell: UICollectionViewCell, SKImageViewDelegate {
    
    var delegate:HomePostCellDelegate?
    
    var post:Post?{
        didSet{
            guard let post = self.post else{ return }
            photoImageView.loadImage(with: post.imageUrl)
            usernameLabel.text = post.user.username
            profileImageView.loadImage(with: post.user.imageUrl)
            favButton.setImage(post.hasLiked ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            self.setAttributedText(with: post)
        }
    }
    
    fileprivate func setAttributedText(with post:Post){
        let attributedText = NSMutableAttributedString(string: "\(post.user.username) ", attributes: TextAttributes.titleAttributes)
        attributedText.append(NSAttributedString(string: post.captionText, attributes: TextAttributes.captionAttributes))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: TextAttributes.gapAttributes))
        
        let dateStr = Utility.convertTimestampToReadableDateString(timestamp: post.timestamp)
        attributedText.append(NSAttributedString(string: dateStr, attributes: TextAttributes.timestampAttributes))
        usernameAndCaptionLabel.attributedText = attributedText
    }
    
    fileprivate let profileImageView: SKImageView = {
        let iv = SKImageView(withDoubleTapEnabled: false)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate let usernameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    fileprivate let threeDotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.tintColor = .black
        return button
    }()
    
    fileprivate lazy var photoImageView: SKImageView = {
        let iv = SKImageView(withDoubleTapEnabled: true)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.delegate = self
        return iv
    }()
    
    fileprivate lazy var favButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    fileprivate let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    fileprivate let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    fileprivate let usernameAndCaptionLabel: UILabel = {
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
    
    @objc fileprivate func handleComment(){
        guard let post = post else{ return }
        delegate?.didTapComment(of: post)
    }
    
    @objc fileprivate func handleLike(){
        delegate?.didLikePost(at: self, forceLike: false)
        if post?.hasLiked == false{
            photoImageView.animateHeart()
        }
    }
    
    func didImageDoubleTap() {
        delegate?.didLikePost(at: self, forceLike: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
