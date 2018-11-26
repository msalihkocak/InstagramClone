//
//  UserProfileCell.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 24.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell {
    
    var post:Post?{
        didSet{
            guard let post = post else{ return }
            photoImageView.loadImage(with: post.imageUrl)
        }
    }
    
    lazy var photoImageView: SKImageView = {
        let iv = SKImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gridCell
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
