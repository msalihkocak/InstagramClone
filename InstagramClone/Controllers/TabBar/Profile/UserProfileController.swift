//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate, HomePostCellDelegate {
    
    let headerId = "headerId"
    let gridCellId = "gridCellId"
    let listCellId = "listCellId"
    
    var selectedUser:User?
    var user:User?
    var notificationUserId:String?
    var posts = [Post]()
    
    var isGridBeingShown = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: gridCellId)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: listCellId)
        
        setupLogoutNavButton()
        
//        fetchOrGetUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cursor = nil
        isFirstTimeCallback = true
        isFirstTime = true
        isPagingFinished = false
        fetchOrGetUser()
    }
    
    func fetchOrGetUser(){
        if user == nil{
            if selectedUser != nil{
                user = selectedUser!
                self.navigationItem.rightBarButtonItem = nil
                self.configureUI()
            }else{
                if let userId = notificationUserId{
                    Service.fetchUser(with: userId) { (user) in
                        self.user = user
                        self.configureUI()
                    }
                }else{
                    Service.fetchCurrentUser { (user) in
                        self.user = user
                        self.configureUI()
                    }
                }
            }
        }else{
            self.configureUI()
        }
    }
    
    func configureUI(){
        guard let user = user else{ return }
        self.navigationItem.title = user.username
        fetchFollowersAndFollowings(of: user)
//        fetchPosts(of: user)
        self.posts.removeAll(keepingCapacity: false)
        fetchPostsPaginated(of: user)
    }
    
    func fetchFollowersAndFollowings(of user:User){
        Service.fetchFollower(ofUserWith: user.uid, completionBlock: { (followers) in
            self.user?.followers = followers
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        
        Service.fetchFollowing(ofUserWith: user.uid) { (followings) in
            self.user?.followings = followings
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchPosts(of user:User){
        self.posts.removeAll(keepingCapacity: false)
        Service.fetchPostsChildAdded(of: user, completion: { (post) in
            self.posts.insert(post, at: 0)
            self.user?.postsCount += 1
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    var cursor: String?
    var isFirstTime = true
    var isFirstTimeCallback = true
    var isPagingFinished = false
    
    func fetchPostsPaginated(of user:User){
        var limitedOrderedPostsOfUser = Database.database().reference().child("posts").child(user.uid).queryOrdered(byChild: "timestamp").queryLimited(toLast: 4)
        if !isFirstTime{
            limitedOrderedPostsOfUser = limitedOrderedPostsOfUser.queryEnding(atValue: cursor)
        }else{
            isFirstTime = false
        }
        limitedOrderedPostsOfUser.observeSingleEvent(of: .value) { (snapshot) in
            guard var childSnapshots = snapshot.children.allObjects as? [DataSnapshot] else{ return }
            guard let values = childSnapshots.first?.value as? [String:Any] else { return }
            guard let cursorTimestamp = values["timestamp"] as? String else{ return }
            self.cursor = cursorTimestamp
            if !self.isFirstTimeCallback{
                childSnapshots.removeLast()
            }else{
                self.isFirstTimeCallback = false
            }
            self.isPagingFinished = childSnapshots.count == 0 ? true : false
            childSnapshots.reverse()
            childSnapshots.forEach({ (snapshot) in
                guard var values = snapshot.value as? [String:Any] else{ return }
                values["postId"] = snapshot.key
                values["user"] = user
                let post = Post(with: values)
                self.posts.append(post)
            })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupLogoutNavButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func didSwitchToGrid() {
        isGridBeingShown = true
        collectionView.reloadData()
    }
    
    func didSwitchToList() {
        isGridBeingShown = false
        collectionView.reloadData()
    }
    
    @objc func handleLogout(){
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Log out", style: .destructive) { (action) in
            do{
                try Auth.auth().signOut()
                guard let user = self.user else{ return }
                Service.removeFcmTokenOfUser(with: user.uid, completionBlock: {
                    let loginController = LoginController()
                    let navController = UINavigationController(rootViewController: loginController)
                    self.present(navController, animated: true, completion: nil)
                })
            }catch let error{
                print("Failed to sign out", error.localizedDescription)
            }
        })
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == posts.count - 1 && !isPagingFinished{
            if let user = self.user{
                fetchPostsPaginated(of: user)
            }
        }
        if isGridBeingShown{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellId, for: indexPath) as! UserProfileCell
            cell.post = posts[indexPath.item]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            cell.delegate = self
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.headerDelegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.33333333
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridBeingShown{
            let width = view.frame.width / 3 - 0.66666667
            return CGSize(width: width, height: width)
        }else{
            let height = view.frame.width + 166
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func didTapComment(of post:Post) {
        let commentController = CommentController()
        commentController.post = post
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didLikePost(at cell: HomePostCell) {
        // Perform like on post and wait for the result to animate like button
        guard let indexPath = collectionView.indexPath(for: cell) else{ return }
        let postToBeLiked = posts[indexPath.row]
        Service.like(postToBeLiked) {
            self.posts[indexPath.row].hasLiked = !postToBeLiked.hasLiked
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}
