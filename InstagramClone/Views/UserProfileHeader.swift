//
//  UserProfileHeader.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red.withAlphaComponent(0.15)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, tConst: 12, lead: leadingAnchor, lConst: 12, trail: nil, trConst: 0, bot: nil, bConst: 0, height: 80, width: 80)
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
    }
    
    var user:User?{
        didSet{
            setupProfileImage()
        }
    }
    
    fileprivate func setupProfileImage(){
        guard let userLocal = user else { return }
        guard let url = URL(string: userLocal.imageUrl) else{ return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let err = error{
                print("Error while getting profile image:", err.localizedDescription)
                return
            }
            guard let data = data else{ return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }).resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
