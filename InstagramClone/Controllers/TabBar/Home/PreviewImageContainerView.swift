//
//  PreviewImageContainerView.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 25.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Photos

class PreviewImageContainerView: UIView {
    
    let previewImageView = UIImageView()
    
    let crossButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSaveTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 20, paddingRight: 0, width: 50, height: 50)
        
        addSubview(crossButton)
        crossButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
    }
    
    @objc func handleCancel(){
        self.removeFromSuperview()
    }
    
    @objc func handleSaveTapped(){
        guard let image = previewImageView.image else{ return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let error = error{
                print("Failed to save photo to library:", error.localizedDescription)
                return
            }
            print("Image saved to library successfully!")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.textAlignment = .center
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.layer.cornerRadius = 8
                savedLabel.clipsToBounds = true
                savedLabel.textColor = .white
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.numberOfLines = 0
                savedLabel.frame = CGRect(x: 0, y: 0, width: 190, height: 60)
                savedLabel.center = self.center
                self.addSubview(savedLabel)
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    UIView.animate(withDuration: 0.5, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                    }, completion: { (completed) in
                        savedLabel.removeFromSuperview()
                    })
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
