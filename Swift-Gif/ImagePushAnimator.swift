//
//  ImagePushAnimator.swift
//  Swift-Gif
//
//  Created by Paul Chavarria Podoliako on 9/13/14.
//  Copyright (c) 2014 AnyTap. All rights reserved.
//

import Foundation
protocol ImagePushAnimatorProtocol {
    func transitioningImageView() -> UIImageView
    func transitioningGif() -> Gif
}

class ImagePushAnimator : NSObject, UIViewControllerAnimatedTransitioning{
    var isPresenting = false
    
    
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Grab the from and to view controllers from the context
        
        
        // Set our ending frame. We'll modify this later if we have to
        let centerFrame = transitionContext.containerView().bounds
        
        if (self.isPresenting) {
            
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as ViewController
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as DetailViewController
        
            transitionContext.containerView().addSubview(fromViewController.view)
            transitionContext.containerView().addSubview(toViewController.view)
            
            let imageFrom = fromViewController.transitioningImageView()
            let initialRect = imageFrom.superview?.convertRect(imageFrom.frame, toView: fromViewController.view) as CGRect!
            let imageTo = toViewController.transitioningImageView()
            let finalRect = imageTo.superview?.convertRect(imageTo.frame, toView: toViewController.view) as CGRect!
            
            imageTo.frame = initialRect
            transitionContext.containerView().addSubview(toViewController.transitioningImageView())
            toViewController.view.alpha = 0.0
            
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options:.CurveEaseIn, animations: { () -> Void in

                imageTo.frame = finalRect
                toViewController.view.alpha = 1.0
                
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(true)
            })
            
        }
        else {
            
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as DetailViewController
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ViewController
            
            transitionContext.containerView().addSubview(toViewController.view)
            transitionContext.containerView().addSubview(fromViewController.view)
            
            let imageTo = toViewController.transitioningImageView()
            let imageFrom = fromViewController.transitioningImageView()
            let finalRect = imageTo.convertRect(imageTo.frame, toView: toViewController.view)
            
            transitionContext.containerView().addSubview(imageFrom)
            
            imageTo.alpha = 0.0
            
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options:.CurveEaseIn, animations: { () -> Void in
                
                fromViewController.transitioningImageView().frame = finalRect
                fromViewController.view.alpha = 0.0
                
                }, completion: { (finished) -> Void in
                    imageTo.alpha = 1.0
                    transitionContext.completeTransition(true)
                    // iOS8 bug temporal fixup http://stackoverflow.com/a/24589312/2690973
                    UIApplication.sharedApplication().keyWindow.addSubview(toViewController.view)
            })
        }
    }
}