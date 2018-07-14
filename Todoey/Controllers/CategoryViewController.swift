//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hosseinipour, Milad on 7/12/18.
//  Copyright © 2018 Amtrak. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var catArray : Results<TaskCategory>?
    
//    var catArray : [TaskCategory] = [TaskCategory]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catArray?.count ?? 1
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var catTitle = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if catTitle.text != "" {
//                let newCategory = TaskCategory(context: self.context)
                let newCategory = TaskCategory()
                newCategory.name = catTitle.text!
                newCategory.color = UIColor.randomFlat.hexValue()
//                newCategory.color = UIColor(randomFlatColorOf:.light).hexValue()
//                self.catArray.append(newCategory)
                self.tableView.reloadData()
                self.saveCategories(category : newCategory)
            }
        }
        alert.addAction(action)
        alert.addTextField { (catTextField) in
            catTextField.placeholder = "Category"
            catTitle = catTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    func loadCategories(){
        catArray = realm.objects(TaskCategory.self)
        
//        let request : NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
//        do{
//            catArray = try context.fetch(request)
////            print(itemArray.count)
//        } catch{
//            print("Error Fetching Data from Context \(error)")
//        }
    }
    
    func saveCategories(category : TaskCategory){
        do{
//            try self.context.save()
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error Saving to the Database\(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryforDeletion = self.catArray?[indexPath.row]{
            do{
                try self.realm.write {
                    //// To delete an object from Realm
                    self.realm.delete(categoryforDeletion)
                }
            }
            catch{
                print("Error saving done status \(error)")
            }
        }
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = catArray?[indexPath.row].name ?? "No Categories Added Yet"
        cell.backgroundColor = UIColor(hexString: catArray?[indexPath.row].color ?? "1D9BF6")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let catindex = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray?[catindex.row]
        }
    }

}
