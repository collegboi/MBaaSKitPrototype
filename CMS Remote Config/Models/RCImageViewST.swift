//
//  ImageEnum.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation


enum RCImageContentMode : String {
    
    case scaleToFill = "scaleToFill"
    
    case scaleAspectFit = "scaleAspectFit"
    
    case scaleAspectFill = "scaleAspectFill"
    
    case redraw = "redraw"
    
    case center = "center"
    
    case top = "top"
    
    case bottom = "bottom"
    
    case left = "left"
    
    case right = "right"
    
    case topLeft = "topLeft"
    
    case topRight = "topRight"
    
    case bottomLeft = "bottomLeft"
    
    case bottomRight = "bottomRight"
    
    static let allRCImageContentModes = [ scaleToFill, scaleAspectFit, scaleAspectFill, redraw,
                                        center, top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight]
    
    init(id: Int) {
        switch id {
        case 0:
            self = .scaleToFill
        case 1:
            self = .scaleAspectFit
        case 2:
            self = .scaleAspectFill
        case 3:
            self = .redraw
        case 4:
            self = .center
        case 5:
            self = .top
        case 6:
            self = .bottom
        case 7:
            self = .left
        case 8:
            self = .right
        case 9:
            self = .topLeft
        case 10:
            self = .topRight
        case 11:
            self = .bottomLeft
        case 12:
            self = .bottomRight
        default:
            self = .scaleAspectFit
        }
    }
}

enum RCBoolean : String {
    case True = "True"
    case False = "False"
    
    static let allRCBooleans = [True, False]
    
    init(id: Int) {
        switch id {
        case 0:
            self = .False
        default:
            self = .True
        }
    }
}

struct RCImageViewST {
    
    var _rcImageContentMode : RCImageContentMode!
    var _isHidden : RCBoolean!
    var _imageName : String!
    
    var rcImageContentMode: RCImageContentMode {
        return _rcImageContentMode
    }
    
    var isHidden : RCBoolean {
        return _isHidden
    }
    
    var imageName : String {
        return _imageName
    }
    
}
