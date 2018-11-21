//
//  RegisterController.swift
//  InstagramClone
//
//  Created by BTK Apple on 21.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .registerButton
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, tConst: 40, lead: nil, lConst: 0, trail: nil, trConst: 0, bot: nil, bConst: 0, height: 140, width: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputAreaView()
    }
    
    func setupInputAreaView(){
        let inputAreaView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])
        inputAreaView.axis = .vertical
        inputAreaView.distribution = .fillEqually
        inputAreaView.spacing = 10
        
        view.addSubview(inputAreaView)
        
        inputAreaView.anchor(top: plusPhotoButton.bottomAnchor, tConst: 20, lead: view.leadingAnchor, lConst: 40, trail: view.trailingAnchor, trConst: 40, bot: nil, bConst: 0, height: 200, width: nil)
    }
    
    @objc fileprivate func dismissKeyboard(){
        [emailTextField, usernameTextField, passwordTextField].forEach({$0.resignFirstResponder()})
    }
}
