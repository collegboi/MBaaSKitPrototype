//
//  DetailViewController.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

protocol ChildNameDelegate {
    func dataChanged(configFile: Config)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var colorPickerView : RCColorPickerView?
    
    var slideUpTextView : RCTextView?
    
     var delegate: ChildNameDelegate?
    
    var pickedRowNo : Int?
    
    var detailType : ListType?
    
    var language: String?
    
    var translationStruct: Translations?
    
    var detailValues: Config? {
        didSet {
            // Update the view.
            
        }
    }

    func configureView() {
        
        switch self.detailType! {
        case .ColorType:
            tableView.register( ColorsTableViewCell.self)
            break
        case .ControllerType:
            tableView.register(ControllersTableViewCell.self)
            break
        case .LanguageType:
            tableView.register(LanguagesTableViewCell.self)
            self.getRemoteTranslationFiles(lang: self.language!)
            break
        case .MainSettingType:
            tableView.register(LanguagesTableViewCell.self)
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = self.language ?? "Detail"
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.sendFiles))
        self.navigationItem.leftBarButtonItem = saveButton
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewRow))
        self.navigationItem.rightBarButtonItem = addButton
        
        if self.detailType != nil && self.detailValues != nil {
            self.configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addNewRow() {
        
        switch self.detailType! {
        case .ColorType:
            self.loadColorView()
            break
        case .ControllerType:
            self.loadTextView()
            break
        case .LanguageType:
            self.loadTextView()
            break
        case .MainSettingType:
            self.loadTextView()
            break
        }

    }
}

extension DetailViewController {
    
    func sendFiles() {
        
        switch self.detailType! {
        case .ColorType, .ControllerType, .MainSettingType:
            self.sendConfigFiles()
            break
        case .LanguageType:
            self.sendTranslationFiles()
            break
        }

    }
    
    func sendTranslationFiles() {
        
        guard let json = self.translationStruct?.toJSON() else  {
            return
        }
        let data = self.convertStringToDictionary(text: json)
        self.sendRemoteConfigFiles(json: data!, type: "translation&language="+self.language!)
    }
    
    func sendConfigFiles() {
        
        if let json = self.detailValues!.toJSON() {
            let data = self.convertStringToDictionary(text: json)
            self.sendRemoteConfigFiles(json: data!, type: "config")
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func sendRemoteConfigFiles( json : [String : AnyObject], type: String ) {
        // Correct url and username/password
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataSend.php?type="+type
        HTTPSConnection.httpRequest(params: json, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    
                    self.tableView.reloadData()
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func getRemoteTranslationFiles(lang: String = "") {
        // Correct url and username/password
        
        let newDic = [String:Any]()
        self.translationStruct = Translations(dict: newDic)
        
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataRequest.php?type=translation&language="+lang
        let dic = [String: AnyObject]()
        HTTPSConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("getRemoteTranslationFiles Succeeded")
                    guard let alltranslations = HTTPSConnection.parseJSONTranslations(data: data) else {
                        
                        if self.language != self.detailValues?.languagesList[0] {
                            self.getRemoteTranslationFiles(lang: (self.detailValues?.languagesList[0])!)
                        }
                        
                        return
                    }
                    self.translationStruct = alltranslations
                    
                    
                    //                    if let json = self.config!.toJSONObjects() {
                    //                        print(json)
                    //                        self.sendRemoteConfigFiles(json: json)
                    //                    }
                    
                    self.tableView.reloadData()
                } else {
                    print("getRemoteTranslationFiles Error")
                }
            }
        }
    }

}

extension DetailViewController {
    
    func loadColorView() {
        
        self.navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.colorPickerView = RCColorPickerView.nib(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height ))
        
        if self.pickedRowNo != nil {
            
            let colorObject = self.detailValues?.colors[self.pickedRowNo!]
            self.colorPickerView?.red = Float((colorObject?.red)!)
            self.colorPickerView?.blue = Float((colorObject?.blue)!)
            self.colorPickerView?.green = Float((colorObject?.green)!)
            self.colorPickerView?.alphaVal = Float((colorObject?.alpha)!)
            self.colorPickerView?.colorName = colorObject!.name
        } else {
            self.colorPickerView?.red = 255/2
            self.colorPickerView?.blue = 255/2
            self.colorPickerView?.green = 255/2
            self.colorPickerView?.alphaVal = 1
        }
        
        self.colorPickerView?.doneButton.addTarget(self, action: #selector(self.saveButton), for: .touchUpInside)
        self.colorPickerView?.cancelButton.addTarget(self, action: #selector(self.cancelButton), for: .touchUpInside)
        
        self.view.addSubview(colorPickerView!)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.colorPickerView?.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.width)
        }, completion: nil)
    }
    
    func removeColorView( update : Bool ) {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.colorPickerView?.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.width)
        }, completion:{
            (value: Bool) in
            
            if update {
                
                if self.pickedRowNo == nil {
                    
                    
                    let newColor = RCColor(blue: CGFloat(self.colorPickerView!.blue),
                                           green: CGFloat(self.colorPickerView!.green),
                                           red: CGFloat(self.colorPickerView!.red),
                                           alpha: CGFloat(self.colorPickerView!.alphaVal),
                                           name: self.colorPickerView!.colorName)
                    self.detailValues?.colors.append(newColor)
                    
                } else {
                
                    self.detailValues?.colors[self.pickedRowNo!].alpha = CGFloat(self.colorPickerView!.alphaVal)
                    self.detailValues?.colors[self.pickedRowNo!].red = CGFloat(self.colorPickerView!.red)
                    self.detailValues?.colors[self.pickedRowNo!].green = CGFloat(self.colorPickerView!.green)
                    self.detailValues?.colors[self.pickedRowNo!].blue = CGFloat(self.colorPickerView!.blue)
                    self.detailValues?.colors[self.pickedRowNo!].name = self.colorPickerView!.colorName
                }
                
                self.tableView.reloadData()
                self.updateParentData()
            }
            
            self.colorPickerView?.removeFromSuperview()
            self.colorPickerView = nil
            self.navigationController?.navigationItem.rightBarButtonItem?.isEnabled = false
            
        })
    }

    func saveButton() {
        self.removeColorView(update: true)
    }
    
    func cancelButton() {
        self.removeColorView(update: false)
    }
    
    func updateParentData() {
        
        if let del = delegate {
            del.dataChanged(configFile: self.detailValues!)
        }
    }
    
}

extension DetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "controllerSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row] as! NSDate
                if let controller = segue.destination as? EditObjectTableViewController {
                    controller.controllerProperties = self.detailValues?.controllers[indexPath.row].objectsList
                    controller.controllerRow = indexPath.row
                }
                
                // controller.detailItem = object
                //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                //controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    //unwind segue function
    @IBAction func unwindToVC(_ segue:UIStoryboardSegue) {
        
         if(segue.source .isKind(of: EditObjectTableViewController.self)) {
         
            print("Unwind function")
            let view2:EditObjectTableViewController = segue.source as! EditObjectTableViewController
            self.detailValues?.controllers[view2.controllerRow].objectsList = view2.controllerProperties
         }
    }

}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.detailType! == .ControllerType {
            self.performSegue(withIdentifier: "controllerSegue", sender: self)
        } else if self.detailType! == .ColorType {
            self.pickedRowNo = indexPath.row
            self.loadColorView()
        } else if self.detailType! == .LanguageType || self.detailType! == .MainSettingType {
            self.pickedRowNo = indexPath.row
            self.loadTextView()
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard self.detailType != nil else {
            return 0
        }
        
        switch self.detailType! {
        case .ColorType:
            return self.detailValues!.colors.count
        case .ControllerType:
            return self.detailValues!.controllers.count
        case .LanguageType:
            guard let list = self.translationStruct?.translationList else {
                return 0
            }
            return list.count
        default:
            return self.detailValues!.mainSettings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.detailType! {
        case .ColorType:
            let cell = tableView.dequeReusableCell(forIndexPath: indexPath as NSIndexPath) as ColorsTableViewCell
            cell.configureCell(rccolor: (self.detailValues?.colors[indexPath.row])!)
            return cell
        case .ControllerType:
            let cell = tableView.dequeReusableCell(forIndexPath: indexPath as NSIndexPath) as ControllersTableViewCell
            cell.configureCell(rcController: (self.detailValues?.controllers[indexPath.row])!)
            return cell
        case .MainSettingType:
            let cell = tableView.dequeReusableCell(forIndexPath: indexPath as NSIndexPath) as LanguagesTableViewCell
            let (key, value) = (self.detailValues?.mainSettings.getObjectAtIndex(index: indexPath.row))!
            cell.configureCell(key: key, value: value)
            return cell
        default:
            let cell = tableView.dequeReusableCell(forIndexPath: indexPath as NSIndexPath) as LanguagesTableViewCell
            guard  let (optKey, optValue) = self.translationStruct?.translationList?.getValueAtIndex(index: indexPath.row) else {
                return cell
            }
            cell.configureCell(key: optKey, value: optValue as AnyObject)
            return cell
        }
    
    }
}
