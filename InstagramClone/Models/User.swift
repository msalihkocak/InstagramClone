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
    var uid:String
    let username:String
    let email:String
    let imageUrl:String
    
    init() {
        uid = ""
        username = ""
        email = ""
        imageUrl = ""
    }
    
    init(snapshot:DataSnapshot) {
        guard let valuesDict = snapshot.value as? [String:Any] else{
            self.init()
            return
        }
        self.init(with: valuesDict)
    }
    
    init(with values:[String:Any]) {
        uid = values["uid"] as? String ?? ""
        username = values["username"] as? String ?? ""
        email = values["email"] as? String ?? ""
        imageUrl = values["imageUrl"] as? String ?? ""
    }
    
    init(uid:String, snapshot:DataSnapshot) {
        self.init(snapshot: snapshot)
        self.uid = uid
    }
}
