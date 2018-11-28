//
//  SKImageView.swift
//  InstagramClone
//
//  Created by BTK Apple on 28.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

var imageCache = [String:UIImage]()

class SKImageView:UIImageView{
    var lastURLUsedToLoadImage: String?
    
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
}
