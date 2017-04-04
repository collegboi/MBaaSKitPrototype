//
//  MasterViewController.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, ChildNameDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [String]()

    var config : Config?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.objects += ["Controllers", "Main Settings" , "Colors"]
        
        self.getRemoteConfigFiles()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        self.config?.languagesList.append("Russian")
        self.tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                if indexPath.section == 0 {
                    
                    switch indexPath.row {
                    case 0:
                        controller.detailType = ListType.ControllerType
                        break
                    case 1:
                        controller.detailType = ListType.MainSettingType
                        break
                    default:
                        controller.detailType = ListType.ColorType
                    }
                    
                } else {
                    
                    controller.detailType = ListType.LanguageType
                    controller.language = self.config?.languagesList[indexPath.row]
                    
                }
                
                controller.detailValues = self.config
                
               // controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
}
extension MasterViewController {

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return objects.count
        default:
            guard self.config?.languagesList != nil else {
                return 0
            }
            return self.config!.languagesList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = objects[indexPath.row]
        default:
            cell.textLabel!.text = self.config?.languagesList[indexPath.row]
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && ( indexPath.row != 0 && indexPath.section == 1) && indexPath.section == 0 {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

extension MasterViewController {
    
    func getRemoteConfigFiles() {
        // Correct url and username/password
        
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataRequest.php?type=config"
        let dic = [String: AnyObject]()
        HTTPSConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    self.config = HTTPSConnection.parseJSONConfig(data: data)
                
                    
//                    if let json = self.config!.toJSONObjects() {
//                        print(json)
//                        self.sendRemoteConfigFiles(json: json)
//                    }
                    
                    self.tableView.reloadData()
                } else {
                    print("Error")
                }
            }
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
    
    func sendRemoteConfigFiles( json : [String : AnyObject] ) {
        // Correct url and username/password
        
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataSend.php?type=config"
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

}
extension MasterViewController {
    
    func dataChanged(configFile: Config) {
        self.config?.colors = configFile.colors
    }
    
}
