//
//  ViewController.swift
//  Todoay
//
//  Created by Abdulrahman Alangari on 2019-07-14.
//  Copyright © 2019 Dhoo00m. All rights reserved.
//

import UIKit

class TodoayViewController: UITableViewController  {
    
    var arr = [Item]()
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(filePath)
       loadData()
        
        
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
        
        self.saveData()
        
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
            
            self.saveData()
            
           
        }
        alert.addTextField { (alertText) in
            alertText.placeholder = "create Item"
            addedText = alertText
            
        }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveData(){
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(arr)
            try data.write(to: filePath!)
        }catch {
            print("Error Encoding Item Array \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadData () {
        
        let data = try? Data(contentsOf: filePath!)
        
        let decoder = PropertyListDecoder()
        do {
        
            arr = try decoder.decode([Item].self, from: data!)
            
        }catch {
            print("Error Dcoding Item Array \(error)")
            
        }
    }
    
    
    }



