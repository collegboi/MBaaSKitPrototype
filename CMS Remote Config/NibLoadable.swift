//
//  NibLoadable.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
    associatedtype T: UIView
    
    static func nib(named: String?, frame: CGRect?) -> T?
}

extension NibLoadable where Self: UIView {
    
    private static func nibbedView<T: UIView>(named: String) -> T? {
        return Bundle(for: self).loadNibNamed(named, owner: nil, options: nil)?.first as? T
    }
    
    private static func typedNibbedView() -> Self? {
        return nibbedView(named: String(describing: self))
    }
    
    static func nib(named: String? = nil, frame: CGRect? = nil) -> Self? {
        
        guard let view = typedNibbedView() else { return nil }
        
        if let frame = frame {
            view.frame = frame
            view.layoutIfNeeded()
        }
        
        return view
    }
}
 
