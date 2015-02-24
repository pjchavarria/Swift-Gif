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
        self.imageView.setImageWithURL(NSURL(string: image.fixedWidthUrl!),placeholderImage:UIImage())
    }
}
