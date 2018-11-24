//
//  MainTabBarController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 22.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarContorller: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        self.delegate = self
        
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: false, completion: nil)
                return
            }
        }
        setupViewControllers()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2{
            let addPhotoController = AddPhotoController(collectionViewLayout:UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: addPhotoController)
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func setupViewControllers(){
        let homeController = HomeController(collectionViewLayout:UICollectionViewFlowLayout())
        let homeNavController = templateNavController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: homeController)
        
        let searchController = SearchController(collectionViewLayout:UICollectionViewFlowLayout())
        let searchNavController = templateNavController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: searchController)
        
        let plusNavController = templateNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected") , unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        let favController = FavoritesController(collectionViewLayout:UICollectionViewFlowLayout())
        let favsNavController = templateNavController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"), rootViewController: favController)
        
        let userController = UserProfileController(collectionViewLayout:UICollectionViewFlowLayout())
        let userNavController = templateNavController(selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: userController)
        
        viewControllers = [homeNavController, searchNavController, plusNavController, favsNavController, userNavController]
        
        guard let items = tabBar.items else{ return }
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(selectedImage:UIImage, unselectedImage:UIImage, rootViewController:UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        viewController.tabBarItem.image = unselectedImage
        viewController.tabBarItem.selectedImage = selectedImage
        return UINavigationController(rootViewController: viewController)
    }
}

