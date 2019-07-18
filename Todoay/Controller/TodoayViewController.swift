//
//  ViewController.swift
//  Todoay
//
//  Created by Abdulrahman Alangari on 2019-07-14.
//  Copyright © 2019 Dhoo00m. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class TodoayViewController: UITableViewController  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var arr = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
   override func viewWillAppear(_ animated: Bool) {
    
        title = selectedCategory!.name
        if let hexColour = selectedCategory?.colour{
            guard let nvc = navigationController?.navigationBar else {fatalError("Navigation Controller does not exit")}
            
            nvc.barTintColor = UIColor(hexString: hexColour)
            searchBar.barTintColor = UIColor(hexString: hexColour)
            nvc.tintColor = ContrastColorOf(UIColor(hexString: hexColour)!, returnFlat: true)
            nvc.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: hexColour)!, returnFlat: true)]
        }
    }

    //MARK - TableView DataScource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todoaycell", for: indexPath) as! SwipeTableViewCell
        let item = arr[indexPath.row]
        cell.textLabel?.text = item.title
        
        if let itemColour = UIColor(hexString: selectedCategory!.colour!)?.darken(byPercentage: CGFloat (indexPath.row) / CGFloat(arr.count)) {
            
            cell.backgroundColor = itemColour
            cell.textLabel?.textColor = ContrastColorOf(itemColour, returnFlat: true)
        }
        
        cell.delegate = self
        
        cell.accessoryType = item.checking == true ? .checkmark : .none
        
       
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arr[indexPath.row].checking == false {
            arr[indexPath.row].checking = true
            
        }else {
            arr[indexPath.row].checking = false
        }
        
        self.saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       
        }
    
    //MARK - TableView Delegate Methods
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var addedText = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "Todoay list Items", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
    
            let newItem = Item(context: self.context)
            
            newItem.title = addedText.text!
            newItem.checking = false
            newItem.isComponentOf = self.selectedCategory
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
        
        do {
            try
                context.save()
        }catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadData (arg  request : NSFetchRequest<Item> = Item.fetchRequest(),arg   predicate : NSPredicate? = nil) {
        
        let catPredecate = NSPredicate(format: "isComponentOf.name MATCHES %@", selectedCategory!.name!)
        
        if let addPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredecate , addPredicate])
        }else {
            request.predicate = catPredecate
        }
        
        
        do {
            try
          arr = context.fetch(request)
            
        }catch {
            print("Error reading Context \(error)")
        }
        tableView.reloadData()
    }

   }
extension TodoayViewController : UISearchBarDelegate ,SwipeTableViewCellDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(arg : request, arg : predicate)
      
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.arr[indexPath.row])
            self.arr.remove(at: indexPath.row)
            
            
            self.saveData()
            self.loadData()
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-icon")
        
        return [deleteAction]
    }
    
}



