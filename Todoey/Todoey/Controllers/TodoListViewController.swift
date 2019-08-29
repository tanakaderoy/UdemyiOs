//
//  ViewController.swift
//  Todoey
//
//  Created by Tanaka Mazivanhanga on 7/18/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var items = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        if let items1 = defaults.array(forKey: "TodoListArray")  as? [Item]{
        //            items = items1
        //        }
        // Do any additional setup after loading the view.
    }
    
    func loadItems(){
        //soecify data type
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        fetchRequest(request: request)
        tableView.reloadData()
        
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        
        }else{
            
        }
        
    }
    func fetchRequest(request: NSFetchRequest<Item>, predicate: NSPredicate? = nil){
         let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
       
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
             request.predicate = compoundPredicate
        }else{
            request.predicate = categoryPredicate
        }
        
        
       
        do {
            items = try context.fetch(request)
        } catch  {
            print("error \(error)")
        }
        
        
    }

    
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        //        lengthy if else
        //        if item.done {
        //             cell.accessoryType = .checkmark
        //        }else{
        //             cell.accessoryType = .none
        //        }
        cell.accessoryType = item.done ? .checkmark: .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        let item = items[indexPath.row]
        //        if item.done == false{
        //            item.done = true
        //        }else{
        //            item.done = false
        //        }
        item.done = !item.done
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(items[indexPath.row])
            items.remove(at: indexPath.row)
            
            do {
                try context.save()
            }
            catch{
                
            }
            
        }
        saveItems()
    }
    //MARK - Add new Item
    func saveItems(){
        
        do{
            try context.save()
            
        }catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text{
                //self.itemArray.append(text)
                if text != ""{
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                    newItem.parentCategory = self.selectedCategory
                self.items.append(newItem)
                self.saveItems()
                }else{
                    textField.endEditing(true)
                   
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            if searchText == ""{
                searchBar.endEditing(true)
            }else{
                let request: NSFetchRequest<Item> = Item.fetchRequest()
                let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
                request.predicate = predicate
                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
                request.sortDescriptors = [sortDescriptor]
                fetchRequest(request: request, predicate: predicate)
                tableView.reloadData()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

