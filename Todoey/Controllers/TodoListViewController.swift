//
//  ViewController.swift
//  Todoey
//
//  Created by Hosseinipour, Milad on 7/10/18.
//  Copyright © 2018 Amtrak. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray : [Item] = [Item]()
    var selectedCategory : TaskCategory? {
        didSet{
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


//    let defaults = UserDefaults.standard
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

//        // To re-read data from user defaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
    }

    //MARK - TableView Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
//        // To delete from the itemArray and SQLite database
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        self.tableView.reloadData()
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            itemArray[indexPath.row].done = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            itemArray[indexPath.row].done = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        saveData()
    }
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var taskTitle = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when the user clicks on the Add Iteme UIAlert
            if taskTitle.text != "" {
                
//                let newItem = Item()
                
                let newItem = Item(context: self.context)
                
                newItem.title = taskTitle.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                self.tableView.reloadData()
                
                self.saveData()
//                self.defaults.set(self.itemArray, forKey: "TodoListArray")
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Task"
            taskTitle = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
  
    func saveData(){
//        let encoder = PropertyListEncoder()
        
        do{
            try self.context.save()
//            print(dataFilePath!)
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
        }
        catch{
//            print("Error encoding \(error)")
            print("Error Saving Context\(error)")
        }
    }

// LoadData for Plist encoder data persistence
//    func loadData(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                print ("Error decode \(error)")
//            }
//        }
//    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate , categoryPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
            print(itemArray.count)
        } catch{
            print("Error Fetching Data from Context \(error)")
        }
    }
    

}

//MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request)
        self.tableView.reloadData()

//        do{
//            itemArray = try context.fetch(request)
////            print(itemArray.count)
//        } catch{
//            print("Error Fetching Data from Context \(error)")
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}



