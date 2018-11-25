//
//  SKAnimationPresenter.swift
//  InstagramClone
//
//  Created by Mehmet Salih Koçak on 25.11.2018.
//  Copyright © 2018 msalihkocak. All rights reserved.
//

import UIKit

class SKAnimationPresenter: NSObject, UIViewControllerAnimatedTransitioning{
    
    var isDismissing:Bool?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // My custom transition animation code logic
        let containerView = transitionContext.containerView
        guard let isDismissing = isDismissing else{ return }
        guard let toView = transitionContext.view(forKey: .to) else{ return }
        guard let fromView = transitionContext.view(forKey: .from) else{ return }
        
        containerView.addSubview(toView)
        
        let startingXOfTo = isDismissing ? toView.frame.width : -toView.frame.width
        let endingXOfFrom = isDismissing ? -fromView.frame.width : fromView.frame.width
        let startingFrame = CGRect(x: startingXOfTo, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: endingXOfFrom, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
