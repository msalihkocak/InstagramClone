//
//  SKLabel.swift
//  InstagramClone
//
//  Created by BTK Apple on 28.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class SKLabel:UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textAlignment = .center
        layer.cornerRadius = 8
        layer.masksToBounds = true
        font = UIFont.boldSystemFont(ofSize: 18)
        textColor = .white
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: super.intrinsicContentSize.width + 16, height: super.intrinsicContentSize.height + 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
