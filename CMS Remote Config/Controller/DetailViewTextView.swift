//
//  DetailViewTextView.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 02/11/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

extension DetailViewController {
    
    func loadTextView() {
        
        self.slideUpTextView = RCTextView.nib(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width-50, height: 300 ))
        self.slideUpTextView?.layer.borderColor = UIColor.black.cgColor
        self.slideUpTextView?.layer.borderWidth = 2
        self.slideUpTextView?.layer.cornerRadius = 10
        
        self.slideUpTextView?.keyTextField.delegate = self.slideUpTextView
        self.slideUpTextView?.valueTextField.delegate = self.slideUpTextView
        
        var key: String = ""
        var value: String = ""
        
        
        if self.pickedRowNo != nil {
        
            switch self.detailType! {
                case .ControllerType:
                    key = "Controller"
                    value = (self.detailValues?.controllers[self.pickedRowNo!].name)!
                    break
                case .LanguageType:
                    guard  let (optKey, optValue) = self.translationStruct?.translationList?.getValueAtIndex(index: self.pickedRowNo!) else {
                            break
                    }
                    key = optKey
                    value = optValue
                break
            case .MainSettingType:
                guard  let (optKey, optValue) = self.detailValues?.mainSettings?.getValueAtIndex(index: self.pickedRowNo!) else {
                    break
                }
                key = optKey
                value = optValue
            default:
                //tableView.register(LanguagesTableViewCell.self)
                break
            }
        } else {
            
            if self.detailType! == .ControllerType {
                key = "Controller"
            }
        }
        
        self.slideUpTextView?.keyTextField.text = key
        self.slideUpTextView?.valueTextField.text = value
        
        self.slideUpTextView?.cancelButton.addTarget(self, action: #selector(self.cancelButtonAction), for: .touchUpInside)
        self.slideUpTextView?.doneButton.addTarget(self, action: #selector(self.doneButtonAction), for: .touchUpInside)
        
        self.view.addSubview(self.slideUpTextView!)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.slideUpTextView?.frame = CGRect(x: 0, y: 70, width: self.view.frame.width - 50, height: 300)
            self.slideUpTextView?.center.x = self.view.center.x
        }, completion: nil)
    }
    
    func doneButtonAction() {
        self.removeTextView(update: true)
    }
    
    func cancelButtonAction() {
        self.removeTextView(update: false)
    }
    
    func removeTextView(update: Bool) {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.slideUpTextView?.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width - 50, height: 250)
        }, completion:{
            (value: Bool) in
            
            if update {
            
                let key = self.slideUpTextView?.keyName ?? ""
            
                let value = self.slideUpTextView?.valueName ?? ""
                
                print(key, value)
            
                switch self.detailType! {
                    case .ColorType:
                        //self.loadColorView()
                    break
                    case .ControllerType:
                        let newController = RCController(name: value)
                        self.detailValues?.controllers.append(newController)
                    break
                    case .LanguageType:
                        self.translationStruct?.translationList[key] = value as AnyObject?
                    break
                case .MainSettingType:
                    self.detailValues?.mainSettings[key] = value
                    break
                }
            }

            self.tableView.reloadData()
            self.slideUpTextView?.removeFromSuperview()
            self.slideUpTextView = nil
            self.pickedRowNo = nil
        })
    }
    

}
