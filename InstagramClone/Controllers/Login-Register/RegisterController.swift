//
//  RegisterController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 21.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let hud = SKActivityIndicator(isWithCancelButton: false, infoText: "Registering user...")
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleImageSelection), for: .touchUpInside)
        return button
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
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Username"
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
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .registerButton
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let mutableAttrString = NSMutableAttributedString(string: "Already have an account? ", attributes: TextAttributes.descAttributes)
        mutableAttrString.append(NSAttributedString(string: "Sign in.", attributes: TextAttributes.signupButtonAttributes))
        button.setAttributedTitle(mutableAttrString, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputAreaView()
        handleTextChange()
    }
    
    func setupInputAreaView(){
        let inputAreaView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])
        inputAreaView.axis = .vertical
        inputAreaView.distribution = .fillEqually
        inputAreaView.spacing = 10
        
        view.addSubview(inputAreaView)
        
        inputAreaView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        hud.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let err = error{
                print("Failed to create user:",err.localizedDescription)
                return
            }
            
            guard let id = result?.user.uid else { return }
            guard let imageData = self.plusPhotoButton.imageView?.image?.jpegData(compressionQuality: 0.2) else{ return }
            
            let storageRef = Storage.storage().reference().child("user-images").child("\(id).jpg")
            storageRef.putData(imageData, metadata: nil, completion: { (meta, error) in
                if let err = error{
                    print("Upload image failed", err.localizedDescription)
                    return
                }
                
                //Getting the download url
                storageRef.downloadURL(completion: { (url, err) in
                    if let error = err{
                        print("Image download url retrieval failed:", error.localizedDescription)
                        return
                    }
                    guard let downloadUrlString = url?.absoluteString else { return }
                    guard let fcmToken = Messaging.messaging().fcmToken else { return }
                    let userValues = ["username": username, "email":email, "imageUrl": downloadUrlString, "fcmToken":fcmToken]
                    let values = [id:userValues]
                    Service.insertUserToDatabase(values: values, completionBlock: { (error) in
                        self.hud.stopAnimating()
                        if let err = error{
                            print("Error while writing user to database", err.localizedDescription)
                            return
                        }
                        print("User succcessfully registered to database")
                        guard let tabbarController = Utility.getMainTabbarController() else{ return }
                        tabbarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    })

                })
            })
        }
    }
    
    @objc func handleTextChange(){
        Utility.validate([emailTextField, usernameTextField, passwordTextField], andExecute: { (isFormValid) in
            Utility.animateButton(button: self.signupButton, withFlag: isFormValid)
        })
    }
    
    @objc func handleGoToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleImageSelection(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
         if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func dismissKeyboard(){
        [emailTextField, usernameTextField, passwordTextField].forEach({$0.resignFirstResponder()})
    }
}
