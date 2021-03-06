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

class SKInputContainerView: UIView, UITextViewDelegate {
    
    var delegate: SKInputContainerViewDelegate?
    
    fileprivate lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .buttonBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var commentTextView:SKTextView = {
        let tv = SKTextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.delegate = self
        return tv
    }()
    
    var commentTextViewHeightAnchor:NSLayoutConstraint?
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        sendButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 8, paddingRight: 2, width: 0, height: 0)
        
        commentTextViewHeightAnchor = commentTextView.heightAnchor.constraint(equalToConstant: 100)
        commentTextViewHeightAnchor?.isActive = true
        
        setupSeperator()
        textViewDidChange(commentTextView)
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
    
    func textViewDidChange(_ textView: UITextView) {
        Utility.validate(commentTextView) { (isValid) in
            self.sendButton.isEnabled = isValid
        }
        
        //width: view.frame.width * 0.15 + 8 + 12
        let submitButtonWidth = frame.width * 0.15
        let commentTextViewWidth = frame.width - submitButtonWidth - 20
        let size = CGSize(width: commentTextViewWidth, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if estimatedSize.height >= 100{
            commentTextViewHeightAnchor?.constant = 100
            commentTextView.isScrollEnabled = true
        }else{
            commentTextViewHeightAnchor?.constant = estimatedSize.height
            commentTextView.isScrollEnabled = false
        }
    }
    
    fileprivate func resetUI(){
        commentTextView.text = ""
        textViewDidChange(commentTextView)
        commentTextView.resignFirstResponder()
        commentTextView.layoutIfNeeded()
        commentTextView.showPlaceholderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
