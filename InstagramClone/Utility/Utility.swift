//
//  Utility.swift
//  InstagramClone
//
//  Created by BTK Apple on 23.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    @objc class func validate(_ textFields:[UITextField], andExecute block:(Bool) -> ()){
        let textsOfTextFields = textFields.compactMap({return $0.text})
        var isFormValid = true
        textsOfTextFields.forEach { (text) in
            if text.count < 1{
                isFormValid = false
                return
            }
        }
        block(isFormValid)
    }
    
    class func animateEnable(of button: UIButton, with block:(() -> Void)?){
        UIView.transition(with: button,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: block,
                          completion: nil)
    }
    
    class func animateButton(button:UIButton, withFlag flag:Bool){
        if flag {
            Utility.animateEnable(of: button) {
                button.backgroundColor = .buttonBlue
                button.isEnabled = true
            }
            return
        }
        Utility.animateEnable(of: button) {
            button.backgroundColor = .registerButton
            button.isEnabled = false
        }
    }
}
