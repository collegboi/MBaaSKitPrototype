//
//  Float+Ext.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 02/11/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation

extension Float {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
