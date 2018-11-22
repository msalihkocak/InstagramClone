//
//  Service.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import Foundation
import Firebase

class Service: NSObject {
    
    class func fetchUserInfo(completion: @escaping (User) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let user = User(snapshot: snapshot)
            completion(user)
        }
    }
}
