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
            if text.isEmpty{
                isFormValid = false
                return
            }
        }
        block(isFormValid)
    }
    
    class func validate(_ textView:UITextView, andExecute block:(Bool) -> ()){
        guard let text = textView.text else { return }
        var isTextViewValid = false
        if text.count > 0{
            isTextViewValid = true
        }
        block(isTextViewValid)
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
    
    class func getMainTabbarController() -> MainTabBarContorller?{
        return UIApplication.shared.keyWindow?.rootViewController as? MainTabBarContorller
    }
    
    class func convertTimestampToReadableDateString(timestamp:String) -> String{
        guard let timestamp = TimeInterval(timestamp) else{ return "" }
        let date = Date(timeIntervalSince1970: timestamp)
        return date.timeAgoDisplay()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/YYY hh:mm"
//        return dateFormatter.string(from: date)
    }
}
