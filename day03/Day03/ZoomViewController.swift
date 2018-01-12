//
//  ZoomViewController.swift
//  Day03
//
//  Created by Simon GAUDIN on 1/12/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class ZoomViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var img:UIImage?
    {
        didSet
        {
            if let i = img
            {
                self.imageView = UIImageView(image: i)
            }
        }
    }
    
    var imageView:UIImageView?
    
    func setZoomScale()
    {
        let xMinZoomScale = self.view.bounds.size.width / (imageView?.bounds.size.width)!
        scrollView.minimumZoomScale = xMinZoomScale
        scrollView.maximumZoomScale = 5
    }
    
    override func viewWillLayoutSubviews() {
        self.setZoomScale()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.addSubview(imageView!)
        scrollView.contentSize = (imageView?.frame.size)!
        self.setZoomScale()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
