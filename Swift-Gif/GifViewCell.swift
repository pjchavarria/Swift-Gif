//
//  GifViewCell.swift
//  Swift-Gif
//
//  Created by Paul Chavarria Podoliako on 9/11/14.
//  Copyright (c) 2014 AnyTap. All rights reserved.
//

import UIKit

class GifViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func maskForGif(image: Gif)
    {
//        self.imageView.alpha = 0.1
//        self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8, 0.8)
//        UIView.animateWithDuration(0.4, animations: { () -> Void in
//            self.imageView.alpha = 1.0
//            self.imageView.transform = CGAffineTransformIdentity
//        })
        self.imageView.setImageWithURL(NSURL(string: image.fixedWidthUrl!),placeholderImage:UIImage())
    }
}
