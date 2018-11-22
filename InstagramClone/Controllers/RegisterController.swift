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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, tConst: 40, lead: nil, lConst: 0, trail: nil, trConst: 0, bot: nil, bConst: 0, height: 140, width: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputAreaView()
        handleTextChange()
    }
    
    func setupInputAreaView(){
        let inputAreaView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])
        inputAreaView.axis = .vertical
        inputAreaView.distribution = .fillEqually
        inputAreaView.spacing = 10
        
        view.addSubview(inputAreaView)
        
        inputAreaView.anchor(top: plusPhotoButton.bottomAnchor, tConst: 20, lead: view.leadingAnchor, lConst: 40, trail: view.trailingAnchor, trConst: 40, bot: nil, bConst: 0, height: 200, width: nil)
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
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
                        print("Upload image failed", error.localizedDescription)
                        return
                    }
                    guard let downloadUrlString = url?.absoluteString else { return }
                    let userValues = ["username": username, "email":email, "imageUrl": downloadUrlString]
                    let values = [id:userValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if let err = error{
                            print("Error while writing user to database", err.localizedDescription)
                            return
                        }
                        print("User succcessfully registered to database", ref)
                    })

                })
            })
        }
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
    
    @objc func handleTextChange(){
        guard let userText =  usernameTextField.text else { return }
        guard let emailText =  emailTextField.text else { return }
        guard let passwordText =  passwordTextField.text else { return }
        if userText.count > 0 && emailText.count > 0 && passwordText.count > 0 {
            animateEnable(of: signupButton) {
                self.signupButton.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
                self.signupButton.isEnabled = true
            }
            return
        }
        animateEnable(of: signupButton) {
            self.signupButton.backgroundColor = .registerButton
            self.signupButton.isEnabled = false
        }
    }
    
    func animateEnable(of button: UIButton, with block:(() -> Void)?){
        UIView.transition(with: button,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: block,
                          completion: nil)
    }
    
    @objc fileprivate func dismissKeyboard(){
        [emailTextField, usernameTextField, passwordTextField].forEach({$0.resignFirstResponder()})
    }
}
