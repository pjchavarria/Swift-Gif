//
//  DetailViewController.swift
//  Swift-Gif
//
//  Created by Paul Chavarria Podoliako on 9/13/14.
//  Copyright (c) 2014 AnyTap. All rights reserved.
//

import Foundation

class DetailViewController: UIViewController, ImagePushAnimatorProtocol  {

    var gif: Gif?
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let unwrappedGif = gif {
            
            self.imageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: unwrappedGif.originalUrl!)), placeholderImage: self.image, success: { (request, response, image) -> Void in
                self.imageView.image = image
                self.backgroundImageView.image = (image.copy() as UIImage)
            }, failure: { (request, response, error) -> Void in
                println("\(error)")
            })
            self.backgroundImageView.image = (self.image?.copy() as UIImage)
            
            sourceLabel.text = gif?.source
            widthLabel.text = gif?.width.description
            heightLabel.text = gif?.height.description
            ratingLabel.text = gif?.rating
        }

    }

    // MARK: - ImagePushAnimatorProtocol

    func transitioningImageView() -> UIImageView {
        return self.imageView
    }
    
    func transitioningGif() -> Gif {
        return self.gif!
    }
    
    // MARK: - @IBAction
    
    @IBAction func closePressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}