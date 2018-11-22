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
}

extension UIView{
    
    func anchor(top:NSLayoutYAxisAnchor?, tConst: CGFloat, lead:NSLayoutXAxisAnchor?, lConst: CGFloat, trail:NSLayoutXAxisAnchor?, trConst: CGFloat, bot:NSLayoutYAxisAnchor?, bConst: CGFloat, height:CGFloat?, width:CGFloat?){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let tp = top{
            self.topAnchor.constraint(equalTo: tp, constant: tConst).isActive = true
        }
        if let ld = lead{
            self.leadingAnchor.constraint(equalTo: ld, constant: lConst).isActive = true
        }
        if let tr = trail{
            self.trailingAnchor.constraint(equalTo: tr, constant: -trConst).isActive = true
        }
        if let bt = bot{
            self.bottomAnchor.constraint(equalTo: bt, constant: -bConst).isActive = true
        }
        if let w = width{
            self.widthAnchor.constraint(equalToConstant: w).isActive = true
        }
        if let h = height{
            self.heightAnchor.constraint(equalToConstant: h).isActive = true
        }
    }
}
