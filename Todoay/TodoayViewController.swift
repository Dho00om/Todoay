//
//  ViewController.swift
//  Todoay
//
//  Created by Abdulrahman Alangari on 2019-07-14.
//  Copyright © 2019 Dhoo00m. All rights reserved.
//

import UIKit

class TodoayViewController: UITableViewController  {
    
    
    var arr = ["go to sleep" , "buy a pillow" , "don't forget the blanket"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }

    //MARK - TableView DataScource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todoaycell", for: indexPath)
        
        cell.textLabel?.text = arr[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print(arr[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       
        }
    //MARK - TableView Delegate Methods
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var addedText = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "Todoay list Items", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        self.arr.append(addedText.text!)
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



