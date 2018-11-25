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
    var followers:[String]
    var followings:[String]
    var postsCount:Int
    
    init() {
        uid = ""
        username = ""
        email = ""
        imageUrl = ""
        followers = [String]()
        followings = [String]()
        postsCount = 0
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
        followers = [String]()
        followings = [String]()
        postsCount = 0
    }
    
    init(uid:String, snapshot:DataSnapshot) {
        self.init(snapshot: snapshot)
        self.uid = uid
    }
    
    func values() -> [String:Any]{
        var values = [String:Any]()
        values["username"] = username
        values["email"] = email
        values["imageUrl"] = imageUrl
        values["followers"] = followers
        values["followings"] = followings
        values["postsCount"] = postsCount
        return values
    }
}
