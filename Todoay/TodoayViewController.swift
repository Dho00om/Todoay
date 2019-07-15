//
//  ViewController.swift
//  Todoay
//
//  Created by Abdulrahman Alangari on 2019-07-14.
//  Copyright © 2019 Dhoo00m. All rights reserved.
//

import UIKit

class TodoayViewController: UITableViewController  {
    
    var defaults = UserDefaults.standard
    
    var arr = [Item]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        arr = defaults.array(forKey: "Array") as! [String]
//        // Do any additional setup after loading the view.
        let newItem1 = Item()
        newItem1.title = "bed"
        arr.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "pillow"
        arr.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "blanket"
        arr.append(newItem3)
        
        if let items = defaults.array(forKey: "Array") as? [Item] {
            arr = items
        }
    }

    //MARK - TableView DataScource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todoaycell", for: indexPath)
        let item = arr[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.checked == true ? .checkmark : .none
        
       
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arr[indexPath.row].checked == false {
            arr[indexPath.row].checked = true
            
        }else {
            arr[indexPath.row].checked = false
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
       
        }
    
    //MARK - TableView Delegate Methods
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var addedText = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "Todoay list Items", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = addedText.text!
            
            self.arr.append(newItem)
            
            self.tableView.reloadData()
            
            self.defaults.setValue(self.arr, forKey: "Array")
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertText) in
            alertText.placeholder = "create Item"
            addedText = alertText
            
        }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
        
    }
    
    
    }



