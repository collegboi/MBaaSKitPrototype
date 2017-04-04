//
//  ColorsTableViewCell.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class ColorsTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var colorView : UIView!
    @IBOutlet weak var colorLabel : UILabel!
    
    func configureCell( rccolor : RCColor ) {
        
        let color = UIColor(red: rccolor.red/255.0, green: rccolor.green/255.0, blue: rccolor.blue/255.0, alpha: rccolor.alpha)
        colorView.backgroundColor = color
        colorLabel.text = rccolor.name
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
