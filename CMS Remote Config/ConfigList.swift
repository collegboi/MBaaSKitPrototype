//
//  ConfigList.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 31/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation



class ConfigList {
    
    class func checkList( property: String ) ->Bool {
        
        var returnVal : Bool = false
        
        switch property {
        case "contentMode":
            returnVal = true
            break
        case "fontSize":
            returnVal = true
            break
        case "isUserInteractionEnabled", "isEnabled", "isHidden":
            returnVal = true
            break
        default: break
        }
        return returnVal
    }
    
    class func getList( property: String ) -> Array<String> {
        
        var returnArray = Array<String>()
        
        switch property {
        case "contentMode":
            returnArray += ["scaleToFill", "scaleAspectFit", "scaleAspectFill", "redraw", "center", "top",
                            "bottom", "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"  ]
            break
        case "fontSize":
            var arr = [Int]()
            arr += 1...100
            let stringArray = arr.map {
                String($0)
            }
            returnArray = stringArray
            break
        case "isUserInteractionEnabled", "isEnabled", "isHidden":
            returnArray.append("False")
            returnArray.append("True")
            break
        default: break
        }
        
        return returnArray
    }
    
    class func getItem( property: String, index : Int ) -> String {
        return ConfigList.getList(property: property).get(index: index)
    }
    
    class func getItemDefault( property: String, index : Int, defaultVal : String ) -> String {
        let value = ConfigList.getItem(property: property, index: index)
        if value.isEmpty {
            return defaultVal
        } else {
            return value
        }
    }
}

extension Array {
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(index: Int) -> String {
        if 0 <= index && index < count {
            
            return self[index] as! String
        } else {
            return ""
        }
    }
}
