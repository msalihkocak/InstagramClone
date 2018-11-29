//
//  UserSearchCell.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 25.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user:User? {
        didSet{
            guard let user = user else{ return }
            profileImageView.loadImage(with: user.imageUrl)
            usernameLabel.text = user.username
        }
    }
    
    let profileImageView:SKImageView = {
        let iv = SKImageView(withDoubleTapEnabled: false)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let seperator = UIView()
        seperator.backgroundColor = .seperator
        
        addSubview(seperator)
        seperator.anchor(top: nil, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
