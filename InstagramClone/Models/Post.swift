//
//  Post.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 24.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    
    var captionText:String
    var imageUrl:String
    var timestamp:String
    var imageWidth:String
    var imageHeight:String
    
    init() {
        captionText = ""
        imageUrl = ""
        timestamp = ""
        imageWidth = ""
        imageHeight = ""
    }
    
    init(snapshot:DataSnapshot) {
        guard let valuesDict = snapshot.value as? [String:Any] else {
            self.init()
            return
        }
        self.init(with: valuesDict)
    }
    
    init(with values:[String:Any]) {
        self.captionText = values["captionText"] as? String ?? ""
        self.imageUrl = values["imageUrl"] as? String ?? ""
        self.timestamp = values["timestamp"] as? String ?? ""
        self.imageWidth = values["imageWidth"] as? String ?? ""
        self.imageHeight = values["imageHeight"] as? String ?? ""
    }
}
