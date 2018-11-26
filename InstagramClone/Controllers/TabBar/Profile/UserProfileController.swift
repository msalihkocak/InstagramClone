//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    let headerId = "headerId"
    let gridCellId = "gridCellId"
    let listCellId = "listCellId"
    
    var selectedUser:User?
    var user:User?
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
        
        fetchOrGetUser()
    }
    
    func fetchOrGetUser(){
        if selectedUser != nil{
            user = selectedUser!
            self.navigationItem.rightBarButtonItem = nil
            self.configureUI()
        }else{
            Service.fetchCurrentUser { (user) in
                self.user = user
                self.configureUI()
            }
        }
    }
    
    func configureUI(){
        guard let user = user else{ return }
        self.navigationItem.title = user.username
        fetchFollowersAndFollowings(of: user)
        fetchPosts(of: user)
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
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
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
        if isGridBeingShown{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellId, for: indexPath) as! UserProfileCell
            cell.post = posts[indexPath.item]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
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
}
