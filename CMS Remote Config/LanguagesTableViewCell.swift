//
//  LanguagesTableViewCell.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class LanguagesTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var stringName : UILabel!
    @IBOutlet weak var stringValue : UILabel!
    
    func configureCell( key: String, value: AnyObject ) {
        self.stringValue.text = "\(value)"
        self.stringName.text = key
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
