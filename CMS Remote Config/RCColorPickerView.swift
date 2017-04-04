//
//  RCColorPickerView.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 31/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class RCColorPickerView: UIView, UITextFieldDelegate, NibLoadable {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var colorName: String = "" {
        didSet {
            self.colorTextField.text = colorName
        }
    }
    
    var red : Float = 124 {
        didSet {
            let redRound = red.roundTo(places: 2)
            self.redTextField.text = "\(redRound)"
            self.redSlider.value = redRound
            self.updateView()
        }
    }
    
    var green : Float = 124 {
        didSet {
            let greenRound = green.roundTo(places: 2)
            self.greenTextField.text = "\(greenRound)"
            self.greenSlider.value = greenRound
            self.updateView()
        }
    }
    
    var blue : Float = 124 {
        didSet {
            let blueRound = blue.roundTo(places: 2)
            self.blueTextField.text = "\(blueRound)"
            self.blueSlider.value = blueRound
            self.updateView()
        }
    }
    
    var alphaVal : Float = 1 {
        didSet {
            self.alphaSlider.value = alphaVal.roundTo(places: 2)
            self.updateView()
        }
    }
    
    @IBAction func redSlider(_ sender: Any) {
        self.red = ( sender as! UISlider).value.roundTo(places: 2)
    }
    
    @IBAction func greenSlider(_ sender: Any) {
        self.green = ( sender as! UISlider).value.roundTo(places: 2)
    }
    
    @IBAction func blueSlider(_ sender: Any) {
        self.blue = ( sender as! UISlider).value.roundTo(places: 2)
    }
    
    @IBAction func alphaSlider(_ sender: Any) {
        self.alphaVal = ( sender as! UISlider).value.roundTo(places: 2)
    }
    
    
    func updateView() {
        
        self.colorName = self.colorTextField.text!
        
        var redColor : CGFloat = 0
        if let n = NumberFormatter().number(from: self.redTextField.text!) {
            redColor = CGFloat(n)
        }
        
        var greenColor : CGFloat = 0
        if let n = NumberFormatter().number(from: self.greenTextField.text!) {
            greenColor = CGFloat(n)
        }
        
        var blueColor : CGFloat = 0
        if let n = NumberFormatter().number(from: self.blueTextField.text!) {
            blueColor = CGFloat(n)
        }
        
        let alpha = self.alphaSlider.value
        
        let color1 = UIColor(red: redColor/255.0, green: greenColor/255.0, blue: blueColor/255.0, alpha: CGFloat(alpha))
        
        self.colorView.backgroundColor = color1
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
