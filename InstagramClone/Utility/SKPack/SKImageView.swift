//
//  SKImageView.swift
//  InstagramClone
//
//  Created by BTK Apple on 28.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

protocol SKImageViewDelegate {
    func didImageDoubleTap()
}

var imageCache = [String:UIImage]()

class SKImageView:UIImageView{
    
    var lastURLUsedToLoadImage: String?
    var delegate:SKImageViewDelegate?
    
    let heartImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "animated_heart").withRenderingMode(.alwaysOriginal)
        iv.alpha = 0.75
        return iv
    }()
    
    init(withDoubleTapEnabled isDoubleTapEnabled:Bool) {
        super.init(frame: .zero)
        isUserInteractionEnabled = true
        
        if isDoubleTapEnabled{
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTap.numberOfTapsRequired = 2
            addGestureRecognizer(doubleTap)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(with urlString:String){
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else{ return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let err = error{
                print("Error while getting profile image:", err.localizedDescription)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let data = data else{ return }
            let image = UIImage(data: data)
            imageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
        }).resume()
    }
    
    @objc fileprivate func handleDoubleTap(_ gesture:UITapGestureRecognizer){
        animateHeart()
        delegate?.didImageDoubleTap()
    }
    
    func animateHeart(){
        addSubview(heartImageView)
        
        heartImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        heartImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        heartImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        heartImageView.popUpAndPopDown()
    }
}
