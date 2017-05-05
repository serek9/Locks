//
//  CGFloatExtension.swift
//  Locks
//
//  Created by Sergio Díaz on 5/5/17.
//  Copyright © 2017 Sergio Díaz. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    public static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min min : CGFloat, max : CGFloat) -> CGFloat{
        return CGFloat.random() * (max - min) + min
    }
}
