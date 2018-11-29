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
    
    class func fetchCurrentUser(completion: @escaping (User) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let user = User(uid: uid, snapshot: snapshot)
            completion(user)
        }
    }
    
    class func fetchUser(with userId:String , completion: @escaping (User) -> ()){
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            let user = User(uid: userId, snapshot: snapshot)
            completion(user)
        }
    }
    
    class func fetchUsers(completion: @escaping ([User]) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let valuesDict = snapshot.value as? [String:Any] else { return }
            var users = [User]()
            valuesDict.forEach({ (key, userValues) in
                guard var values = userValues as? [String:Any] else{ return }
                values["uid"] = key
                let user = User(with: values)
                if user.uid != uid {
                    users.append(user)
                }
            })
            completion(users)
        }
    }
    
    class func fetchPostsChildAdded(of user:User, completion: @escaping (Post) -> ()){
        let reference = Database.database().reference().child("posts").child(user.uid)
        reference.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            guard var valuesDict = snapshot.value as? [String:Any] else { return }
            let postId = snapshot.key
            valuesDict["postId"] = postId
            valuesDict["user"] = user
            let post = Post(with: valuesDict)
            completion(post)
        }
    }
    
    class func fetchPostsValue(ofUserWith id:String, completion: @escaping (Post?) -> ()){
        Service.fetchUser(with: id) { (user) in
            let reference = Database.database().reference().child("posts").child(user.uid)
            reference.queryOrdered(byChild: "creationDate").observeSingleEvent(of: .value) { (snapshot) in
                guard let valuesDict = snapshot.value as? [String:Any] else {
                    completion(nil)
                    return
                }
                for (key, postValues) in valuesDict{
                    guard var values = postValues as? [String:Any] else{
                        completion(nil)
                        return
                    }
                    values["postId"] = key
                    values["user"] = user
                    Service.fetchIfUserLiked(thePostWith: key, completionBlock: { (hasLiked) in
                        values["hasLiked"] = hasLiked
                        let post = Post(with: values)
                        completion(post)
                    })
                }
            }
        }
    }
    
    class func fetchComments(of post:Post, completionBlock:@escaping (Comment) -> ()){
        let commentsRef = Database.database().reference().child("comments").child(post.postId)
        commentsRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let valuesDict = snapshot.value as? [String:Any] else { return }
            valuesDict.forEach({ (commentKey, commentValues) in
                guard var values = commentValues as? [String:Any] else { return }
                guard let userId = values["userId"] as? String else{ return }
                Service.fetchUser(with: userId) { (user) in
                    values["user"] = user
                    let comment = Comment(with: values)
                    completionBlock(comment)
                }
                
            })
        }
    }
    
    class func removeFcmTokenOfUser(with id:String, completionBlock:@escaping () -> ()){
        let values = ["fcmToken": ""]
        Database.database().reference().child("users").child(id).updateChildValues(values) { (error, ref) in
            if let error = error{
                print("Removal of token failed with error:", error.localizedDescription)
                return
            }
            completionBlock()
        }
    }
    
    class func addFcmTokenToUser(with id:String, completionBlock:@escaping () -> ()){
        guard let token = Messaging.messaging().fcmToken else { return }
        let values = ["fcmToken": token]
        Database.database().reference().child("users").child(id).updateChildValues(values) { (error, ref) in
            if let error = error{
                print("Removal of token failed with error:", error.localizedDescription)
                return
            }
            completionBlock()
        }
    }
    
    class func makeComment(withText body:String, to post:Post, completionBlock:@escaping () -> ()){
        let newCommentRef = Database.database().reference().child("comments").child(post.postId).childByAutoId()
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["userId": uid, "timestamp":"\(timestamp)", "body": body] as [String : Any]
        newCommentRef.updateChildValues(values) { (error, ref) in
            if let error = error{
                print("Error occured while inserting comment:",error.localizedDescription)
                return
            }
            print("Comment posted successfully")
            completionBlock()
        }
    }
    
    class func insertUserToDatabase(values:[String:Any], completionBlock:@escaping (Error?) -> ()){
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
            completionBlock(error)
        })
    }
    
    class func fetchFollowing(ofUserWith id:String, completionBlock:@escaping ([String]) -> ()){
        let followingRef = Database.database().reference().child("following").child(id)
        Service.fetchFollowerOrFollowingNode(with: followingRef, completionBlock: completionBlock)
    }
    
    class func fetchFollower(ofUserWith id:String, completionBlock:@escaping ([String]) -> ()){
        let followerRef = Database.database().reference().child("followers").child(id)
        Service.fetchFollowerOrFollowingNode(with: followerRef, completionBlock: completionBlock)
    }
    
    fileprivate class func fetchFollowerOrFollowingNode(with ref:DatabaseReference, completionBlock:@escaping ([String]) -> ()){
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var ids = [String]()
            guard let valuesDict = snapshot.value as? [String:Any] else {
                completionBlock(ids)
                return
            }
            valuesDict.forEach({ (key, value) in ids.append(key) })
            completionBlock(ids)
        })
    }
    
    class func follow(_ user:User, completionBlock:@escaping () -> ()){
        guard let loggedInUser = Auth.auth().currentUser?.uid else{ return }
        let followingValues = [user.uid:1]
        let followerValues = [loggedInUser:1]
        let rootRef = Database.database().reference()
        rootRef.child("following").child(loggedInUser).updateChildValues(followingValues) { (error, ref) in
            if let err = error{
                print("Following failed with error:", err.localizedDescription)
                return
            }
            print("Added to following list successfully")
            
            rootRef.child("followers").child(user.uid).updateChildValues(followerValues, withCompletionBlock: { (error, ref) in
                if let err = error{
                    print("Follower failed with error:", err.localizedDescription)
                    return
                }
                print("Added to followers list successfully")
                completionBlock()
            })
        }
    }
    
    class func unfollow(_ user:User, completionBlock:@escaping () -> ()){
        guard let loggedInUser = Auth.auth().currentUser else{ return }
        let rootRef = Database.database().reference()
        rootRef.child("following").child(loggedInUser.uid).child(user.uid).removeValue { (error, ref) in
            if let err = error{
                print("Removing from following list failed with error:", err.localizedDescription)
                return
            }
            print("Removed from followings list successfully")
            rootRef.child("followers").child(user.uid).child(loggedInUser.uid).removeValue(completionBlock: { (error, ref) in
                if let err = error{
                    print("Removing from followers list failed with error:", err.localizedDescription)
                    return
                }
                print("Unfollowed successfully")
                completionBlock()
            })
        }
    }
    
    class func like(_ post:Post, forceLike:Bool, completionBlock:@escaping () -> ()){
        guard let loggedInUser = Auth.auth().currentUser else{ return }
        let likePostRef = Database.database().reference().child("likes").child(post.postId)
        let hasLiked = forceLike ? 1 : post.hasLiked == false ? 1 : 0
        let values = [loggedInUser.uid:hasLiked]
        likePostRef.updateChildValues(values) { (error, ref) in
            if let error = error{
                print("Liking failed:",error.localizedDescription)
                return
            }
            completionBlock()
        }
    }
    
    class func fetchIfUserLiked(thePostWith postId:String, completionBlock:@escaping (Bool) -> ()){
        guard let loggedInUser = Auth.auth().currentUser else{ return }
        let likePostRef = Database.database().reference().child("likes").child(postId).child(loggedInUser.uid)
        likePostRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let likedInt = snapshot.value as? Int, likedInt == 1 else {
                completionBlock(false)
                return
            }
            completionBlock(true)
        }
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
