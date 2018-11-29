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
    static let gridCell = UIColor.rgb(245, 245, 245)
}

struct NotificationName {
    static let justPostedAPost = Notification.Name(rawValue: "justPostedAPost")
}

struct TextAttributes {
    static let titleAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)]
    static let headerAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)]
    static let captionAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]
    static let timestampAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)]
    static let gapAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 4)]
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
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
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

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        
        return "\(secondsAgo / week) weeks ago"
    }
}

extension UITabBarController {
    func hideTabBarAnimated(hide:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
                self.tabBar.transform = CGAffineTransform(translationX: 0, y: 50)
            } else {
                self.tabBar.transform = CGAffineTransform.identity
            }
        })
    }
}

extension UIView{
    func popUpAndPopDown(){
        self.alpha = 0.75
        layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                self.alpha = 0
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        })
    }
}
