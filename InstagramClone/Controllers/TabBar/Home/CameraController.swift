//
//  CameraController.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 25.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate{
    
    let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCaptureTapped), for: .touchUpInside)
        return button
    }()
    
    let goToHomeFeedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleGoToHomeFeedTapped), for: .touchUpInside)
        return button
    }()
    
    var captureSession = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        setupCaptureSession()
        setupHud()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    let animationPresenter = SKAnimationPresenter()
//    let dismissAnimationPresenter = SKAnimationPresenter()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationPresenter.isDismissing = false
        return animationPresenter
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationPresenter.isDismissing = true
        return animationPresenter
    }
    
    @objc func handleCaptureTapped(){
        let settings = AVCapturePhotoSettings()
        guard let formatType = settings.availablePreviewPhotoPixelFormatTypes.first else{ return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey: formatType] as [String : Any]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func handleGoToHomeFeedTapped(){
        dismiss(animated: true) {
            self.captureSession.stopRunning()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error{
            print("Photo processing failed with error:", error.localizedDescription)
            return
        }
        guard let imageData = photo.fileDataRepresentation() else{ return }
        let previewImage = UIImage(data: imageData)
        
        let imageContainerView = PreviewImageContainerView()
        imageContainerView.previewImageView.image = previewImage
        
        view.addSubview(imageContainerView)
        imageContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    fileprivate func setupHud(){
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(goToHomeFeedButton)
        goToHomeFeedButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 40, height: 40)
    }
    
    fileprivate func setupCaptureSession(){
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{ return }
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        }catch let error{
            print("Could not setup camera input:", error.localizedDescription)
        }
        
        //2. setup outputs
        
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.frame
        self.view.layer.addSublayer(previewLayer)
        
        //4. Start the system
        captureSession.startRunning()
    }
}
