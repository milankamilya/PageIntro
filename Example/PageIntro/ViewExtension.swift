//
//  ViewExtension.swift
//  PageIntro
//
//  Created by Milan Kamilya on 23/05/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var rotationAngle: CGFloat {
        get {
            return 0.0
        }
        set {
           self.transform = CGAffineTransform(rotationAngle: (CGFloat(M_PI) * (newValue) / 180.0) )
        }
    }
    
}
