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
    
    class func fetchPostsChildAdded(completion: @escaping (Post) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        let reference = Database.database().reference().child("posts").child(uid)
        reference.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            let post = Post(snapshot: snapshot)
            completion(post)
        }
    }
    
    class func fetchPostsValue(completion: @escaping ([Post]) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        let reference = Database.database().reference().child("posts").child(uid)
        reference.queryOrdered(byChild: "creationDate").observeSingleEvent(of: .value) { (snapshot) in
            guard let valuesDict = snapshot.value as? [String:Any] else { return }
            var posts = [Post]()
            valuesDict.forEach({ (key, postValues) in
                guard var values = postValues as? [String:Any] else{ return }
                let post = Post(with: values)
                posts.append(post)
            })
            completion(posts)
        }

    }
    
    class func insertUserToDatabase(values:[String:Any], completionBlock:@escaping (Error?) -> ()){
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
            completionBlock(error)
        })
    }
    
    class func savePostToDatabase(withImageUrl imageUrl:String, andCaptionText captionText:String, size:CGSize, completionBlock: @escaping (Error?) -> ()){
        let width = Int(size.width)
        let height = Int(size.height)
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["imageUrl":imageUrl,
                      "captionText":captionText,
                      "timestamp":"\(timestamp)",
                      "imageWidth": "\(width)",
                      "imageHeight": "\(height)"]
        Database.database().reference().child("posts").child(uid).childByAutoId().updateChildValues(values) { (error, ref) in
            completionBlock(error)
        }
    }
}
