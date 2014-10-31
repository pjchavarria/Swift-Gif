//
//  ViewController.swift
//  Swift-Gif
//
//  Created by Paul Chavarria Podoliako on 9/11/14.
//  Copyright (c) 2014 AnyTap. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UISearchBarDelegate,ImagePushAnimatorProtocol, UIViewControllerTransitioningDelegate  {

    let gifViewCellIdentifier = "GifCell"
    var images = [Gif]()
    var queryString = ""
    var fetchedImages = 0
    var selectedImageView: UIImageView?
    var selectedGif: Gif?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var infoView: UIVisualEffectView!
    @IBOutlet weak var infoViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        
        // Set different number of columns depending on iPad/iPhone
        let layout = collectionView.collectionViewLayout as CHTCollectionViewWaterfallLayout;
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // iPad
            layout.columnCount = 3
        }else{
            // iPhone/iPod
            layout.columnCount = 2
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        return self.images.count
    }

    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let gifViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(gifViewCellIdentifier, forIndexPath: indexPath) as GifViewCell
        let gifObject = images[Int(indexPath.row)]
        gifViewCell.maskForGif(gifObject);
        
        if indexPath.row == self.fetchedImages - 5 {
            self.fetchedImages = self.images.count + 25
            // Fetch new images
                GiphyAPIClient.sharedInstance.gifsForQuery(queryString,offset: self.images.count, callback: { (imageArray, error) -> () in
                    // Update collection view with new data
                    self.collectionView.performBatchUpdates({ () -> Void in
                        let dataCount = self.images.count
                        self.images += imageArray
                        
                        var indexPaths = [NSIndexPath]()
                        for var i=dataCount; i<dataCount+imageArray.count; i++ {
                            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
                        }
                        
                        self.collectionView.insertItemsAtIndexPaths(indexPaths)
                        
                    }, completion: nil)
            })
        }
        return gifViewCell;
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Select
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as GifViewCell
        
        self.selectedImageView = cell.imageView
        self.selectedGif = images[Int(indexPath.row)]
        
        self.performSegueWithIdentifier("showDetail", sender: nil)
    }
    
    // MARK: - UICollectionViewLayout
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let gifObject = images[Int(indexPath.row)]
        return CGSizeMake(145,(145/CGFloat(gifObject.width))*CGFloat(gifObject.height));
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destinationViewController as DetailViewController
            detailVC.gif = self.selectedGif
            detailVC.image = self.selectedImageView?.image?.copy() as? UIImage
            detailVC.transitioningDelegate = self;
            detailVC.modalPresentationStyle = .Custom;
        }
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        queryString = searchBar.text
        fetchedImages = 0
        
        self.searchBar.resignFirstResponder()
        self.collectionView.reloadData()
        
        UIView.animateWithDuration(0.6,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .CurveEaseIn,
            animations: { () -> Void in
            self.infoView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.01, 0.01)
        }) { (finished) -> Void in
            self.infoView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.0, 0.0)
        }
        
        GiphyAPIClient.sharedInstance.gifsForQuery(queryString,offset: 0, callback: { (imageArray, error) -> () in
            self.images = imageArray
            self.fetchedImages = self.images.count
            if self.images.count == 0 {
                self.infoView.layer.removeAllAnimations()
                UIView.animateWithDuration(1.0,
                    delay: 0.0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 1.0,
                    options: .BeginFromCurrentState,
                    animations: { () -> Void in
                        self.infoViewLabel.text = "No Results :["
                        self.infoView.transform = CGAffineTransformIdentity
                    }) { (finished) -> Void in
                        
                }
            }
            self.collectionView.reloadData()
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text as NSString).length == 0 {
            self.images.removeAll(keepCapacity: true)
            self.collectionView.reloadData()
            UIView.animateWithDuration(1.0,
                delay: 0.0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 1.0,
                options: .CurveEaseIn,
                animations: { () -> Void in
                    self.infoView.transform = CGAffineTransformIdentity
                    self.infoViewLabel.text = "Search for Gifs!"
                }) { (finished) -> Void in
                    
            }
        }
    }
    
    
    // MARK: - ImagePushAnimatorProtocol
    
    func transitioningImageView() -> UIImageView {
        return self.selectedImageView!
    }
    
    func transitioningGif() -> Gif {
        return self.selectedGif!
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ImagePushAnimator()
        animator.isPresenting = true
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ImagePushAnimator()
        return animator
    }
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

