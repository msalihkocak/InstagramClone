//
//  SKActivityIndicator.swift
//  Dedi
//
//  Created by BTK Apple on 17.11.2018.
//  Copyright © 2018 Open Whisper Systems. All rights reserved.
//

import UIKit

protocol SKActivityIndicatorDelegate {
    func didTapCancel()
}

class SKActivityIndicator: UIView {
    
    var delegate: SKActivityIndicatorDelegate?
    
    fileprivate var shouldShowCancelButton = false
    
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: .whiteLarge)
        aiView.startAnimating()
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    
    fileprivate let activityIndicatorWrapper:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let bottomHalf: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    fileprivate let indicatorLabel:SKLabel = {
        let label = SKLabel()
        return label
    }()
    
    init(isWithCancelButton:Bool, infoText:String) {
        super.init(frame: .zero)
        self.shouldShowCancelButton = isWithCancelButton
        self.indicatorLabel.text = infoText
        
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicatorWrapper)
        setupWrapper()
        
        addSubview(bottomHalf)
        setupBottomHalf()
        
        isHidden = true
    }
    
    fileprivate func setupBottomHalf(){
        [bottomHalf.topAnchor.constraint(equalTo: centerYAnchor),
        bottomHalf.bottomAnchor.constraint(equalTo: bottomAnchor),
        bottomHalf.leadingAnchor.constraint(equalTo: leadingAnchor),
        bottomHalf.trailingAnchor.constraint(equalTo: trailingAnchor)].forEach({$0.isActive = true})
        
        if shouldShowCancelButton{
            bottomHalf.addSubview(cancelButton)
            
            [cancelButton.centerXAnchor.constraint(equalTo: bottomHalf.centerXAnchor),
             cancelButton.centerYAnchor.constraint(equalTo: bottomHalf.centerYAnchor),
             cancelButton.widthAnchor.constraint(equalToConstant: 120),
             cancelButton.heightAnchor.constraint(equalToConstant: 45)].forEach({$0.isActive = true})
        }
    }
    
    fileprivate func setupWrapper(){
        [activityIndicatorWrapper.centerXAnchor.constraint(equalTo: centerXAnchor),
        activityIndicatorWrapper.centerYAnchor.constraint(equalTo: centerYAnchor),
        activityIndicatorWrapper.widthAnchor.constraint(equalToConstant: 80),
        activityIndicatorWrapper.heightAnchor.constraint(equalToConstant: 80)].forEach({$0.isActive = true})
        
        addSubview(indicatorLabel)
        indicatorLabel.anchor(top: activityIndicatorWrapper.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        indicatorLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        activityIndicatorWrapper.addSubview(activityIndicator)
        setupActivityIndicator()
    }
    
    fileprivate func setupActivityIndicator(){
        [activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorWrapper.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorWrapper.centerYAnchor),
         activityIndicator.widthAnchor.constraint(equalToConstant: 40),
         activityIndicator.heightAnchor.constraint(equalToConstant: 40)].forEach({$0.isActive = true})
    }
    
    public func startAnimating(){
        guard let mainWindow = UIApplication.shared.keyWindow else { return }
        mainWindow.addSubview(self)
        
        [centerXAnchor.constraint(equalTo: mainWindow.centerXAnchor),
         centerYAnchor.constraint(equalTo: mainWindow.centerYAnchor),
         widthAnchor.constraint(equalTo: mainWindow.widthAnchor),
         heightAnchor.constraint(equalTo: mainWindow.heightAnchor)].forEach({$0.isActive = true})
        
        isHidden = false
        activityIndicator.startAnimating()
    }
    
    public func stopAnimating(){
        isHidden = true
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
    
    @objc func handleCancel(){
        delegate?.didTapCancel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
