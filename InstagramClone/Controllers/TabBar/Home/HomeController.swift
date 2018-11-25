//
//  HomeController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 23.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshControl), name: NotificationName.justPostedAPost, object: nil)
        
        setupRefreshControl()
        setupNavigationBar()
        fetchPostsForHomeFeed()
    }
    
    func setupRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing", attributes: TextAttributes.titleAttributes)
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func handleRefreshControl(){
        fetchPostsForHomeFeed()
    }
    
    @objc func handleCameraTapped(){
        let cameraController = CameraController()
//        cameraController.modalTransitionStyle = .partialCurl
        present(cameraController, animated: true, completion: nil)
    }
    
    func fetchPostsForHomeFeed(){
        guard let loggedInUserId = Auth.auth().currentUser?.uid else{ return }
        Service.fetchFollowing(ofUserWith: loggedInUserId) { (followingIds) in
            self.posts.removeAll(keepingCapacity: false)
            // Perfectly described :)
            var usersIdsWhichTheirPostsWillBeShownInHomeFeed = followingIds
            // We also want to see our posts as well
            usersIdsWhichTheirPostsWillBeShownInHomeFeed.append(loggedInUserId)
            usersIdsWhichTheirPostsWillBeShownInHomeFeed.forEach({ (userId) in
                Service.fetchPostsValue(ofUserWith: userId) { (posts) in
                    self.posts.append(contentsOf: posts)
                    self.posts.sort(by: {$0.timestamp > $1.timestamp})
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            })
        }
    }
    
    func setupNavigationBar(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCameraTapped))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //36 + 8 + 8 + view.frame.width + 12 + 40 + 12 + 12
        let height = view.frame.width + 166
        return CGSize(width: view.frame.width, height: height)
    }
}
