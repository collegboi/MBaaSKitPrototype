//
//  DataViewable.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit

public protocol DataViewable {
    
    func reloadData()
}

extension UITableView : DataViewable {}
extension UICollectionView : DataViewable {}


public extension UITableView {
    
    public static var defaultCellIdentifier: String {
        return "Cell"
    }
    
    public subscript(indexPath: NSIndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: UITableView.defaultCellIdentifier, for: indexPath as IndexPath)
    }
    
    public subscript(indexPath: NSIndexPath, identifier: String) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath as IndexPath)
    }
    
    public func registerNib(nibName: String, cellIdentifier: String = defaultCellIdentifier, bundleIdentifier: String? = nil) {
        self.register(UINib(nibName: nibName,
                               bundle: bundleIdentifier != nil ? Bundle(identifier: bundleIdentifier!) : nil),
                         forCellReuseIdentifier: cellIdentifier)
    }
}

