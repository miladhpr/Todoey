//
//  ViewController.swift
//  Todoey
//
//  Created by Hosseinipour, Milad on 7/10/18.
//  Copyright © 2018 Amtrak. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var itemArray : Results<Item>?
//    var itemArray : [Item] = [Item]()
    let realm = try! Realm()
    var selectedCategory : TaskCategory? {
        didSet{
            loadData()
        }
    }
    @IBOutlet var searchBar: UISearchBar!
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//    let defaults = UserDefaults.standard
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }
        
    override func viewWillAppear(_ animated : Bool){
        title = selectedCategory!.name
        
        if let colorHex = selectedCategory?.color{
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does Not Exist!")}
            
            if let navBarColor = UIColor(hexString: colorHex){
                navBar.barTintColor = navBarColor
                searchBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                
            }
        }
    }

    override func viewWillDisappear(_ animated : Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError()}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
    }
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

//        // To re-read data from user defaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }

    //MARK - TableView Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            cell.backgroundColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count)) ?? FlatWhite()
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }else{
            cell.textLabel?.text = itemArray?[indexPath.row].title ?? "No Items Added Yet"
        }
        
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
        
        // To update data using SQLite
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            itemArray?[indexPath.row].done = false
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            itemArray?[indexPath.row].done = true
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//        saveData()
        
        //To update using Realm
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    //// To delete an object from Realm
                    // realm.delete(item)
                    item.done = !item.done
                    }
            }
            catch{
                print("Error saving done status \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var taskTitle = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when the user clicks on the Add Iteme UIAlert
            if taskTitle.text != "" {
                
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = taskTitle.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                            print("Error saving new items \(error)")
                        }
                    }
                  self.tableView.reloadData()
                }
                
                
//                let newItem = Item()
                
//                let newItem = Item(context: self.context)
//
//                newItem.title = taskTitle.text!
//                newItem.done = false
//                newItem.parentCategory = self.selectedCategory
//
//                self.itemArray.append(newItem)
//                self.tableView.reloadData()
//
//                self.saveData()
////                self.defaults.set(self.itemArray, forKey: "TodoListArray")
//            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Task"
            taskTitle = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
  
//    func saveData(){
//        let encoder = PropertyListEncoder()
        
//        do{
//            try self.context.save()
//            print(dataFilePath!)
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        }
//        catch{
//            print("Error encoding \(error)")
//            print("Error Saving Context\(error)")
//        }
//h    }

 //LoadData using Realm
    func loadData(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
// LoadDate using CoreData
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

    // LoadData for Plist encoder data persistence
//    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
////        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate , categoryPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//        do{
//            itemArray = try context.fetch(request)
//            print(itemArray.count)
//        } catch{
//            print("Error Fetching Data from Context \(error)")
//        }
//    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            } catch{
                print("Error deleting item \(error)")
            }
        }
    }
    
}



//MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//        loadData(with: request)
//        self.tableView.reloadData()

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



