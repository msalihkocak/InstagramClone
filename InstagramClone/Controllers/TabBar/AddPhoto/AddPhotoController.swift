//
//  AddPhotoController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 23.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import Photos

class AddPhotoController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        collectionView.backgroundColor = .white
        collectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AddPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        setupNavigationButtons()
        fetchPhotos()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func setupNavigationButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext(){
        let sharePhotoController = SharePhotoController()
        sharePhotoController.imageToShare = self.selectedImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    var imageAssets = [ImageAsset]()
    var selectedImage: UIImage?{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
            }
        }
    }
    var selectedImageAsset: ImageAsset?{
        didSet{
            guard let imageAsset = selectedImageAsset else{ return }
            selectedImage = imageAsset.image
            self.fetchSingle(imageAsset.asset)
        }
    }
    
    fileprivate func assetFetchOptions() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    func fetchPhotos(){
        DispatchQueue.global(qos: .background).async {
            let allPhotos = PHAsset.fetchAssets(with: .image, options: self.assetFetchOptions())
            allPhotos.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image{
                        self.imageAssets.append(ImageAsset(image: image, asset: asset))
                    }
                    if count == allPhotos.count - 1{
                        if let firstImageAsset = self.imageAssets.first{
                            self.selectedImageAsset = firstImageAsset
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
            })
        }
    }
    
    fileprivate func fetchSingle(_ asset:PHAsset){
        DispatchQueue.global(qos: .background).async {
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 600, height: 600)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                if let image = image{
                    self.selectedImage = image
                }
            })
        }
    }
    
    //MARK: CollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddPhotoCell
        cell.photoImageView.image = nil
        cell.photoImageView.image = imageAssets[indexPath.item].image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImageAsset = imageAssets[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! AddPhotoHeader
        guard let image = self.selectedImage else { return header }
        header.photoImageView.image = image
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 4 - 0.75
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.25
    }
}

struct ImageAsset {
    let image:UIImage
    let asset:PHAsset
}
