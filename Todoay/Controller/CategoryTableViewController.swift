//
//  CategoryTableViewController.swift
//  Todoay
//
//  Created by Abdulrahman Alangari on 2019-07-16.
//  Copyright © 2019 Dhoo00m. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var arrCat = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    //MARK: TableView Datascource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCat.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoayCell", for: indexPath)
        let category = arrCat[indexPath.row]
        cell.textLabel?.text = category.name
        
        
        return cell
    }
    //MARK: TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destenationVC = segue.destination as! TodoayViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destenationVC.selectedCategory = arrCat[indexPath.row]
        }
        
    }
    
    
    
    //MARK: Data Manipulation Methods
    func saveCategory () {
        do {
            try context.save()
            
        }catch {
            
            print("Error Saving Category \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategory (arg  requestCat : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            try
          arrCat = context.fetch(requestCat)
        }catch{
            print("Error reading Data \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    
    //MARK: Add Category
    
    
    @IBAction func addCategoty(_ sender: UIBarButtonItem) {
        
        var addedCat = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = addedCat.text!
            
            self.arrCat.append(newCategory)
            
            self.saveCategory()
            
            
        }
        alert.addTextField { (alertText) in
            alertText.placeholder = "create Category"
            addedCat = alertText
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
