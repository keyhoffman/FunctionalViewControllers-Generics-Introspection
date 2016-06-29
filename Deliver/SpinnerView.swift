//
//  SpinnerView.swift
//  Deliver
//
//  Created by Key Hoffman on 6/29/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

class SpinnerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        let r = CAReplicatorLayer()
        let dot = CALayer()
        let shrink = CABasicAnimation(keyPath: "transform.scale")
        
        let nrDots: Int = 15
        let angle = CGFloat(2*M_PI) / CGFloat(nrDots)
        let duration: CFTimeInterval = 1.5
        
        r.bounds = CGRect(origin: self.center, size: self.frame.size)
        r.cornerRadius = 10.0
        r.backgroundColor = UIColor(white: 0.0, alpha: 0.75).CGColor
        r.position = self.center
        r.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        r.instanceDelay = duration/Double(nrDots)
        r.instanceCount = nrDots
        
        dot.bounds = CGRect(x: 0.0, y: 0.0, width: 14.0, height: 14.0)
        dot.position = CGPoint(x: 20, y: 20)
        dot.backgroundColor = UIColor(white: 0.8, alpha: 1.0).CGColor
        dot.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        dot.borderWidth = 1.0
        dot.cornerRadius = 2.0
        dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
        
        shrink.fromValue = 1.0
        shrink.toValue = 0.1
        shrink.duration = duration
        shrink.repeatCount = Float.infinity
        
        dot.addAnimation(shrink, forKey: nil)
        r.addSublayer(dot)
        
        self.layer.addSublayer(r)
    }
}
