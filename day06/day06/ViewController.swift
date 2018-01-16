//
//  ViewController.swift
//  day06
//
//  Created by Simon GAUDIN on 1/16/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var viewShapes: UIView!
    
    var dynamicAnimator: UIDynamicAnimator?
    let gravityBehavior = UIGravityBehavior()
    let collisionBehavior = UICollisionBehavior()
    let elasticityBehavior = UIDynamicItemBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.viewShapes)
        gravityBehavior.magnitude = 2
        elasticityBehavior.elasticity = 0.5
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator?.addBehavior(gravityBehavior)
        dynamicAnimator?.addBehavior(collisionBehavior)
        dynamicAnimator?.addBehavior(elasticityBehavior)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        self.viewShapes.addGestureRecognizer(tapGesture)
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
//        self.viewShapes.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer)
    {
        let gestureLocation = gesture.location(in: self.viewShapes)
        let newShape = Shape(xPos: gestureLocation.x - 50, yPos: gestureLocation.y - 50)
        self.viewShapes.addSubview(newShape)
        gravityBehavior.addItem(newShape)
        collisionBehavior.addItem(newShape)
        elasticityBehavior.addItem(newShape)
    }
//
//    @objc func handlePanGesture(gesture: UIPanGestureRecognizer)
//    {
//        if gesture.state == .changed
//        {
//            for v in self.viewShapes.subviews
//            {
//                if v.point(inside: gesture.location(in: self.viewShapes), with: nil)
//                {
//                    let attachmentBehavior = UIAttachmentBehavior(item: v, attachedToAnchor: gesture.location(in: self.viewShapes))
//                    dynamicAnimator?.addBehavior(attachmentBehavior)
//                }
//            }
//        }
//    }
}

