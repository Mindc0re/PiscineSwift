//
//  CollectionViewCell.swift
//  Day03
//
//  Created by Simon GAUDIN on 1/11/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

var loadedPictures: Int?

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var img: UIImage?
    {
        didSet
        {
            DispatchQueue.main.async {
                self.imageView.image = self.img
                self.activityIndicator.stopAnimating()
                loadedPictures! += 1
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
    var dlError: Bool?
    {
        didSet
        {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                loadedPictures! += 1
                self.backgroundColor = UIColor.clear
                self.isUserInteractionEnabled = false
            }
        }
    }
    
}
