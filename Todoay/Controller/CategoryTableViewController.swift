//
//  CategoryTableViewController.swift
//  Todoay
//
//  Created by Abdulrahman Alangari on 2019-07-16.
//  Copyright © 2019 Dhoo00m. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: UITableViewController  {
    
    var arrCat = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategory()
        tableView.rowHeight = 80.0

    }
    
    //MARK: TableView Datascource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCat.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoayCell", for: indexPath) as! SwipeTableViewCell
        let category = arrCat[indexPath.row]
        cell.textLabel?.text = category.name
        
        cell.backgroundColor = UIColor(hexString: arrCat[indexPath.row].colour ?? "941100")
        
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: arrCat[indexPath.row].colour!)!, returnFlat: true)
        
        cell.delegate = self
        
        tableView.separatorStyle = .none
        
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
            
            newCategory.colour = UIColor.randomFlat.hexValue()
            
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
//MARK: Swipe delegate methods

extension CategoryTableViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.arrCat[indexPath.row])
            self.arrCat.remove(at: indexPath.row)
            
            
            self.saveCategory()
            self.loadCategory()
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-icon")
        
        return [deleteAction]
    }
   
}
