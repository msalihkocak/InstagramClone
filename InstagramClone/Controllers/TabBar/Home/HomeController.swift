//
//  HomeController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 23.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationBar()
        
        Service.fetchPostsValue { (posts) in
            self.posts.removeAll(keepingCapacity: false)
            self.posts.append(contentsOf: posts)
            self.posts.sort(by: {$0.timestamp > $1.timestamp})
            self.collectionView.reloadData()
        }
    }
    
    func setupNavigationBar(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
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
