//
//  EditObjectTableViewController.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

enum States {
    case Objects
    case Properties
}


enum PropertyType {
    case colorView
    case pickerView
    case textView
}


class EditObjectTableViewController: UITableViewController {

    var controllerProperties : [RCObject]?
    var properties : [String: Any]?
    var currentStates : States?
    var controllerRow : Int = 0
    
    var objectRow : Int = 0
    
    var pickedIndexPath : IndexPath?
    
    var slideUpPickerView : SlideUpPickerView?
    var slideUpTextView : RCTextView?
    
    var keyList:[String] {
        get{
            return [String](properties!.keys)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentStates = .Objects
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.goBack))
        self.navigationItem.leftBarButtonItem = doneButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewRow))
        self.navigationItem.rightBarButtonItem = addButton
        
        
        tableView.register(ControllersTableViewCell.self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewRow() {
        self.loadTextView()
    }

    
    func goBack() {
        
        if currentStates == .Objects {
            self.controllerProperties?[self.objectRow].objectProperties = self.properties
            //let _ = self.navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "unwindToDetail", sender: self)
            
        } else {
            self.controllerProperties?[self.objectRow].objectProperties = self.properties
            self.currentStates = States.Objects
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.currentStates == States.Objects {
            return self.controllerProperties!.count
        } else {
            return self.properties!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(forIndexPath: indexPath as NSIndexPath) as ControllersTableViewCell
        
        if self.currentStates == States.Objects {
            cell.configureCell(rcController: (self.controllerProperties?[indexPath.row])!)
        } else {
            //let myRowKey = keyList[indexPath.row] //the dictionary key
            //let myRowData = "\(self.properties![myRowKey])" //the dictionary value
            let (myRowKey, myRowData) = self.properties!.getValueAtIndex(index: indexPath.row)
            cell.configureCell(key: myRowKey ,value: myRowData)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.currentStates == States.Objects {
            self.objectRow = indexPath.row
            self.properties = self.controllerProperties?[indexPath.row].objectProperties
            self.currentStates = States.Properties
            self.tableView.reloadData()
        } else {
            self.pickedIndexPath = indexPath
            //self.loadSlideUpView()
            
            //check what type of view to display
            
            let (objectName, _) = (self.properties?.getValueAtIndex(index: indexPath.row))!
            let objectType = self.controllerProperties?[self.objectRow].objectType
            
            if objectType == RCObjectType.Object {
                self.loadTextView()
            } else {
                
                if objectName == "text" || objectName == "fontName" || objectName == "image" {
                    self.loadTextView()
                } else if ConfigList.checkList(property: objectName) {
                    self.loadSlideUpView()
                }
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func loadTextView() {
        
        self.slideUpTextView = RCTextView.nib(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width-50, height: 300 ))
        self.slideUpTextView?.layer.borderColor = UIColor.black.cgColor
        self.slideUpTextView?.layer.borderWidth = 2
        self.slideUpTextView?.layer.cornerRadius = 10
        
        var key = ""
        var value = ""
        
        if self.pickedIndexPath != nil {
        
            if self.currentStates == States.Properties {
        
                (key, value) = (self.properties?.getValueAtIndex(index: self.pickedIndexPath!.row))!
            } else {
                key = (self.controllerProperties?[self.pickedIndexPath!.row].objectType.rawValue)!
                value = (self.controllerProperties?[self.pickedIndexPath!.row].objectName)!
            }
        }
        
        self.slideUpTextView?.keyTextField.text = key
        self.slideUpTextView?.valueTextField.text = value
        
        self.slideUpTextView?.cancelButton.addTarget(self, action: #selector(self.removeTextView), for: .touchUpInside)
        self.slideUpTextView?.doneButton.addTarget(self, action: #selector(self.removeTextView), for: .touchUpInside)
        
        self.view.addSubview(self.slideUpTextView!)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.slideUpTextView?.frame = CGRect(x: 0, y: 10, width: self.view.frame.width - 50, height: 300)
            self.slideUpTextView?.center.x = self.view.center.x
        }, completion: nil)
    }
    
    func removeTextView() {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.slideUpTextView?.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width - 50, height: 250)
        }, completion:{
            (value: Bool) in
            
            
            if self.currentStates == States.Properties {
                
                self.properties?[self.slideUpTextView!.keyTextField.text!] = self.slideUpTextView!.valueTextField.text!
                
            } else {
             
                if self.pickedIndexPath != nil {
                    
                    self.controllerProperties?[self.pickedIndexPath!.row].objectName = self.slideUpTextView!.valueTextField.text!
                    
                } else {
                    
                    let newObject = RCObject(objectName: self.slideUpTextView!.valueTextField.text!, objectType: RCObjectType.Object)
                    self.controllerProperties?.append(newObject)
                }

            }

            self.tableView.reloadData()
            self.slideUpTextView?.removeFromSuperview()
            self.slideUpTextView = nil
        })
    }
    
    
    func loadSlideUpView() {
        
        self.slideUpPickerView = SlideUpPickerView.nib(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300 ))
        
        self.slideUpPickerView!.doneButton.addTarget(self, action: #selector(self.removeSlideUpView), for: .touchUpInside)
        
        self.slideUpPickerView?.pickerView.delegate = self
        self.slideUpPickerView?.pickerView.dataSource = self
        
        self.view.addSubview(slideUpPickerView!)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.slideUpPickerView?.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
        }, completion: nil)
    }
    
    func removeSlideUpView() {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.slideUpPickerView?.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 250)
        }, completion:{
            (value: Bool) in
            self.slideUpPickerView?.removeFromSuperview()
            self.slideUpPickerView = nil
        })
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditObjectTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let (objectName, _) = (self.properties?.getValueAtIndex(index: self.pickedIndexPath!.row))!
        return ConfigList.getList(property: objectName).count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let ( mykey ,_ ) = self.properties!.getValueAtIndex(index: self.pickedIndexPath!.row)
        self.properties?[mykey] = row
        self.tableView.reloadData()
        self.removeSlideUpView()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let (objectName, _) = (self.properties?.getValueAtIndex(index: self.pickedIndexPath!.row))!
        return ConfigList.getItem(property: objectName, index: row)
    }
    
}
