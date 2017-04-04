//
//  RCTextView.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 31/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class RCTextView: UIView, NibLoadable, UITextFieldDelegate {

   
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var keyName: String = "" {
        didSet {
            self.keyTextField.text = keyName
        }
    }
    
    var valueName: String = "" {
        didSet {
            self.valueTextField.text = valueName
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.keyName = self.keyTextField.text!
        self.valueName = self.valueTextField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }

}
