//
//  FavoritesController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 23.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController {
    
    let underConstructionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "under-construction").withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    let underConstructionLabel:UILabel = {
        let label = UILabel()
        var attributedText = NSMutableAttributedString(string: "Under Construction", attributes: TextAttributes.headerAttributes)
        attributedText.append(NSAttributedString(string: "\n\n", attributes: TextAttributes.captionAttributes))
        attributedText.append(NSAttributedString(string: "This screen is under construction.", attributes: TextAttributes.captionAttributes))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .gridCell
        
        let wrapperView = UIView()
        wrapperView.backgroundColor = .clear
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(wrapperView)
        wrapperView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrapperView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        wrapperView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        wrapperView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        
        wrapperView.addSubview(underConstructionImageView)
        underConstructionImageView.anchor(top: wrapperView.topAnchor, left: wrapperView.leftAnchor, bottom: nil, right: wrapperView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        underConstructionImageView.heightAnchor.constraint(equalTo: wrapperView.heightAnchor, multiplier: 0.6)
        
        wrapperView.addSubview(underConstructionLabel)
        underConstructionLabel.anchor(top: wrapperView.centerYAnchor, left: wrapperView.leftAnchor, bottom: wrapperView.bottomAnchor, right: wrapperView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
