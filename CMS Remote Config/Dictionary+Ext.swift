//
//  Dictionary+Ext.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

//
//extension Dictionary {
//    
//    subscript(i:Int) -> (key:Key,value:Value) {
//        get {
//            return ( self.index(forKey: i) )
//        }
//    }
//}

extension Dictionary {
    
    func getValueAtIndex( index: Int ) -> ( String, String ) {
        for( indexVal, value) in enumerated() {
            
            if indexVal == index {
                return ( "\(value.0)" , "\(value.1)" )
            }
        }
        
        return ("", "")
    }
    
    func getObjectAtIndex( index: Int ) -> ( String, AnyObject ) {
        
        for( indexVal, value) in enumerated() {
            
            if indexVal == index {
                return ( "\(value.0)" , value.1 as AnyObject )
            }
        }
        
        return ("", "" as AnyObject)
    }
}
