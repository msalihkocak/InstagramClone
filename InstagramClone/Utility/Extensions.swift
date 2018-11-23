//
//  Extensions.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 21.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let registerButton = UIColor.rgb(149, 204, 244)
    static let seperator = UIColor.rgb(235, 235, 235)
    static let mainBlue = UIColor.rgb(0, 122, 175)
    static let buttonBlue = UIColor.rgb(17, 154, 237)
}

struct TextAttributes {
    static let titleAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)]
    static let descAttributes = [NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
    static let signupButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.buttonBlue, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}