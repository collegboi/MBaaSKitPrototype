//
//  ControllersTableViewCell.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class ControllersTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var controllerName : UILabel!
    @IBOutlet weak var controllerType : UILabel!
    
    func configureCell( rcController : RCController ) {
        
        controllerName.text = rcController.name
        //controllerType.text = rcController.objectType.rawValue
        
    }
    
    func configureCell( rcController : RCObject ) {
        
        controllerName.text = rcController.objectName
        controllerType.text = rcController.objectType.rawValue

    }
    
    func configureCell( key : String, value : String ) {
        let index :Int? = Int(value)
        
        controllerName.text = key
        
        if index != nil {
            
            controllerType.text = ConfigList.getItemDefault(property: key, index: index!, defaultVal: value )
        } else {
            controllerType.text = value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
