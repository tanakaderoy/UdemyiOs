//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tanaka Mazivanhanga on 7/19/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categories = [Category]()
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let text = textField.text{
                //self.itemArray.append(text)
                if text != ""{
                    let newCategory = Category(context: self.context)
                    newCategory.name = text
                    
                    self.categories.append(newCategory)
                    self.saveCategories()
                }else{
                    textField.endEditing(true)
                    
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories(){
        //soecify data type
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        tableView.reloadData()
        fetchRequest(request: request)
        
    }
    func saveCategories(){
        
        do{
            try context.save()
            
        }catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    func fetchRequest(request: NSFetchRequest<Category>){
        do {
            categories = try context.fetch(request)
        } catch  {
            print("error \(error)")
        }
        
    }
    
    
    
    
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    

  
}
