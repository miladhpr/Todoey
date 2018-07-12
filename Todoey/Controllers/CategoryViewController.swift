//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hosseinipour, Milad on 7/12/18.
//  Copyright © 2018 Amtrak. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var catArray : [TaskCategory] = [TaskCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

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
        return catArray.count
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var catTitle = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if catTitle.text != "" {
                let newCategory = TaskCategory(context: self.context)
                newCategory.name = catTitle.text
                self.catArray.append(newCategory)
                self.tableView.reloadData()
                self.saveCategories()
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
        let request : NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
        do{
            catArray = try context.fetch(request)
//            print(itemArray.count)
        } catch{
            print("Error Fetching Data from Context \(error)")
        }
    }
    
    func saveCategories(){
        do{
            try self.context.save()
        }catch{
            print("Error Saving to the Database\(error)")
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let catindex = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[catindex.row]
        }
    }
    //MARK: - Data Manipulation Methods
    
    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
