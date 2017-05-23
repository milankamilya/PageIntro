//
//  PageIntroItem.swift
//  octopull
//
//  Created by Milan Kamilya on 23/05/17.
//  Copyright © 2017 Milan Kamilya. All rights reserved.
//

import UIKit

public class PageIntroItem {
    
    public var rectForCircle: CGRect?
    public var outerCircleRadius: CGFloat?
    public var innerCircleRadius: CGFloat?
    
    public var rectForContentView: CGRect?
    public var contentView: UIView?
    
    public init() {
        innerCircleRadius = 35
        outerCircleRadius = 43
    }
}
