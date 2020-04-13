//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Malik Adebiyi on 2020-04-10.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    

    
    
    // save file to context using core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let categories = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categories.name
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToItems", sender: self)
     }
    
    // prep function is triggered before segue is perfomed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // store refrence to destination view controller
        
       
            let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }

    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }

    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print("add button pressed")
        var textField = UITextField()
        // create text field alert prompt
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        // create an alert action
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
            // creat text fiel alert
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new category"
                textField = alertTextField
            }
            // add action to alert
            alert.addAction(action)
            
            //show the alert
            present(alert, animated: true, completion: nil)
        }
    
    
    
    
    

}
