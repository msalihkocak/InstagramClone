//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var user:User?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogoutNavButton()
        
        Service.fetchUserInfo { (user) in
            self.navigationItem.title = user.username
            self.user = user
            self.collectionView.reloadData()
        }
        
        self.posts.removeAll(keepingCapacity: false)
        Service.fetchPostsChildAdded { (post) in
            self.posts.insert(post, at: 0)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupLogoutNavButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.33333333
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 - 0.66666667
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
