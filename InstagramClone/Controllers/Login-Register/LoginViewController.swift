//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by BTK Apple on 23.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let hud = SKActivityIndicator(isWithCancelButton: false, infoText: "Logging in...")
    
    let logoView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        return view
    }()
    
    let logoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysOriginal)
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .registerButton
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let goToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        let mutableAttrString = NSMutableAttributedString(string: "Don't have an account? ", attributes: TextAttributes.descAttributes)
        mutableAttrString.append(NSAttributedString(string: "Sign up.", attributes: TextAttributes.signupButtonAttributes))
        button.setAttributedTitle(mutableAttrString, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handleGoToRegister), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(goToRegisterButton)
        goToRegisterButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(logoView)
        logoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height / 4)
        
        logoView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: 12).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 0.6).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.5).isActive = true
        
        setupInputAreaView()
    }
    
    func setupInputAreaView(){
        let inputAreaView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        inputAreaView.axis = .vertical
        inputAreaView.distribution = .fillEqually
        inputAreaView.spacing = 10
        
        view.addSubview(inputAreaView)
        
        inputAreaView.anchor(top: logoView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        dismissKeyboard()
        hud.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let err = error{
                print("Sign in failed:", err.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else{ return }
            Service.addFcmTokenToUser(with: uid, completionBlock: {
                self.hud.stopAnimating()
                guard let tabbarController = Utility.getMainTabbarController() else{ return }
                tabbarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc func handleTextChange(){
        Utility.validate([emailTextField, passwordTextField], andExecute: { (isFormValid) in
            Utility.animateButton(button: self.loginButton, withFlag: isFormValid)
        })
    }
    
    @objc func handleGoToRegister(){
        let registerController = RegisterController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    @objc fileprivate func dismissKeyboard(){
        [emailTextField, passwordTextField].forEach({$0.resignFirstResponder()})
    }
}
