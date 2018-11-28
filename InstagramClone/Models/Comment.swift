//
//  Comment.swift
//  InstagramClone
//
//  Created by BTK Apple on 26.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    
    let user:User
    let body:String
    let timestamp:String
    
    init() {
        body = ""
        user = User()
        timestamp = ""
    }
    
    init(snapshot:DataSnapshot) {
        guard let valuesDict = snapshot.value as? [String:Any] else {
            self.init()
            return
        }
        self.init(with: valuesDict)
    }
    
    init(with values:[String:Any]) {
        self.body = values["body"] as? String ?? ""
        self.user = values["user"] as? User ?? User()
        self.timestamp = values["timestamp"] as? String ?? ""
    }
}
