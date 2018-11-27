//
//  SKInputContainer.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 27.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

protocol SKInputContainerViewDelegate {
    func didTapSubmit(with text:String)
}

class SKInputContainerView: UIView {
    
    var delegate: SKInputContainerViewDelegate?
    
    fileprivate lazy var sendButton: UIView = {
        let button = UIButton(type: .system)
        button.tintColor = .buttonBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    fileprivate let commentTextView:SKTextView = {
        let tv = SKTextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
//        textField.placeholder = "Enter comment.."
        return tv
    }()
    
    override var intrinsicContentSize: CGSize{
        if commentTextView.frame.height >= 150{
            commentTextView.isScrollEnabled = true
        }else{
            commentTextView.isScrollEnabled = false
        }
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        sendButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
        commentTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        setupSeperator()
    }
    
    fileprivate func setupSeperator(){
        let seperator = UIView()
        seperator.backgroundColor = .seperator
        
        addSubview(seperator)
        seperator.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    @objc fileprivate func handleSubmit(){
        Utility.validate(commentTextView) { (isValid) in
            if isValid{
                guard let text = self.commentTextView.text else{ return }
                delegate?.didTapSubmit(with: text)
                self.resetUI()
            }
        }
    }
    
    fileprivate func resetUI(){
        commentTextView.text = ""
        commentTextView.resignFirstResponder()
        commentTextView.layoutIfNeeded()
        commentTextView.showPlaceholderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
