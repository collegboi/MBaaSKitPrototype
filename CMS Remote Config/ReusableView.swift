//
//  ReusableView.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

protocol  ReusableView: class { }

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier : String {
        return String(describing: self)
    }
}

