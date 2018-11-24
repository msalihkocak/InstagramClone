//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 24.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController, UITextViewDelegate {
    
    let topShareView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var sharingImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        guard let selectedImage = imageToShare else{ return iv }
        iv.image = selectedImage
        return iv
    }()
    
    lazy var captionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.backgroundColor = .clear
        tv.delegate = self
        return tv
    }()
    
    var imageToShare:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .seperator
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        captionTextView.delegate = self
        
        setupTopShareView()
        textViewDidChange(captionTextView)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @objc func handleShare(){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        guard let image = imageToShare else{ return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else{ return }
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = UUID().uuidString + ".jpg"
        let fileReference = Storage.storage().reference().child("shared-images").child(uid).child(filename)
        fileReference.putData(imageData, metadata: nil) { (metadata, error) in
            if let err = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload shared image:", err.localizedDescription)
                return
            }
            print("Successfully uploaded image:", metadata?.path ?? "")
            fileReference.downloadURL(completion: { (url, error) in
                if let err = error{
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to retrieve download url of shared image:", err.localizedDescription)
                    return
                }
                guard let downloadUrlStr = url?.absoluteString else{ return }
                self.savePost(with: downloadUrlStr, size: image.size)
            })
        }
    }
    
    fileprivate func savePost(with imageUrlString:String, size:CGSize){
        guard let text = self.captionTextView.text, text.count > 0 else{ return }
        Service.savePostToDatabase(withImageUrl: imageUrlString, andCaptionText: text, size: size, completionBlock: { (error) in
            if let err = error{
                print("Saving post to database failed:",err.localizedDescription)
                return
            }
            print("Post saved successfully.")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func setupTopShareView(){
        view.addSubview(topShareView)
        topShareView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        topShareView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        topShareView.addSubview(sharingImageView)
        sharingImageView.anchor(top: nil, left: topShareView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        sharingImageView.centerYAnchor.constraint(equalTo: topShareView.centerYAnchor).isActive = true
        sharingImageView.heightAnchor.constraint(equalTo: topShareView.heightAnchor, multiplier: 0.75).isActive = true
        sharingImageView.widthAnchor.constraint(equalTo: sharingImageView.heightAnchor).isActive = true
        
        topShareView.addSubview(captionTextView)
        captionTextView.anchor(top: sharingImageView.topAnchor, left: sharingImageView.rightAnchor, bottom: sharingImageView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        Utility.validate(captionTextView) { (isValid) in
            navigationItem.rightBarButtonItem?.isEnabled = isValid
        }
    }
}
