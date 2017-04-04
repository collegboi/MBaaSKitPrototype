//
//  NibLoadableView.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

protocol NibLoadableView : class {}

extension NibLoadableView  where Self : UIView {
    
    static var nibName : String {
        return String(describing: self)
    }
}
