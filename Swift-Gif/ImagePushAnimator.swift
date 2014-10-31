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
            
            // Remove all constraints!
            imageTo.removeFromSuperview()
            transitionContext.containerView().addSubview(imageTo)
            imageTo.removeConstraints(imageTo.constraints())
            
            toViewController.view.alpha = 0.0
  
            // Purelayout
            // Instead of setting the frame set the constraints
            let heightConstraint = imageTo.autoSetDimension(.Height, toSize: initialRect.size.height)
            let widthConstraint = imageTo.autoSetDimension(.Width, toSize: initialRect.size.width)
            let leftConstraint = imageTo.autoPinEdgeToSuperviewEdge(.Left, withInset: initialRect.origin.x)
            let topConstraint = imageTo.autoPinEdgeToSuperviewEdge(.Top, withInset: initialRect.origin.y)

            imageTo.layoutIfNeeded()
            
            heightConstraint.autoRemove()
            widthConstraint.autoRemove()
            leftConstraint.autoRemove()
            topConstraint.autoRemove()

            imageTo.autoPinEdgeToSuperviewEdge(.Top, withInset: 30);
            imageTo.autoSetDimension(.Height, toSize: 300);
            imageTo.autoPinEdgeToSuperviewEdge(.Left);
            imageTo.autoPinEdgeToSuperviewEdge(.Right);
            
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options:.CurveEaseIn, animations: { () -> Void in
                // Setted outside, just call layoutIfNeeded
                // imageTo.frame = finalRect
                imageTo.layoutIfNeeded();
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
            
            // Remove all constraints!
            imageFrom.removeFromSuperview()
            transitionContext.containerView().addSubview(imageFrom)
            imageFrom.removeConstraints(imageFrom.constraints())
            
            imageTo.alpha = 0.0
            
            // Instead of setting the frame set the constraints
            imageFrom.autoSetDimension(.Height, toSize: finalRect.size.height)
            imageFrom.autoSetDimension(.Width, toSize: finalRect.size.width)
            imageFrom.autoPinEdgeToSuperviewEdge(.Left, withInset: finalRect.origin.x);
            imageFrom.autoPinEdgeToSuperviewEdge(.Top, withInset: finalRect.origin.y);

            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options:.CurveEaseIn, animations: { () -> Void in
                
                imageFrom.layoutIfNeeded()
                fromViewController.view.alpha = 0.0
                
                }, completion: { (finished) -> Void in
                    imageTo.alpha = 1.0
                    transitionContext.completeTransition(true)
                    // iOS8 bug temporal fixup http://stackoverflow.com/a/24589312/2690973
                    UIApplication.sharedApplication().keyWindow!.addSubview(toViewController.view)
            })
        }
    }
    

}