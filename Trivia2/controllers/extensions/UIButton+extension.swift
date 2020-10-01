//
//  UIButton+extension.swift
//  Trivia2
//
//  Created by Jose Ruben Robles Chavez on 03/09/20.
//  Copyright © 2020 Jose Ruben Robles Chavez. All rights reserved.
//

import Foundation
import UIKit


extension UIButton{
    
    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    func applyRoundCorner(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
    
    func roundedCorners(cornerRadius:CGFloat, borderWidth:CGFloat, borderColor:CGColor ){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.contentEdgeInsets = UIEdgeInsets(top: cornerRadius,
                                              left: cornerRadius,
                                              bottom: cornerRadius,
                                              right: cornerRadius)
    }
    
    
    func pulsate(){
        let pulse = CASpringAnimation(keyPath:"transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        self.layer.add(pulse,forKey: nil)
    }
    
    
   
}
