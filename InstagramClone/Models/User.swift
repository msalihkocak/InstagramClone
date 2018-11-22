//
//  User.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var username:String
    var email:String
    var imageUrl:String
    
    init() {
        username = ""
        email = ""
        imageUrl = ""
    }
    
    init(snapshot:DataSnapshot) {
        self.init()
        guard let valuesDict = snapshot.value as? [String:Any] else { return }
        
        if let uname = valuesDict["username"] as? String{
            username = uname
        }
        if let mail = valuesDict["email"] as? String{
            email = mail
        }
        if let url = valuesDict["imageUrl"] as? String{
            imageUrl = url
        }
    }
}
