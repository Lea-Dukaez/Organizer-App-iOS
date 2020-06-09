//
//  ViewController.swift
//  OrganizerApp
//
//  Created by Léa on 08/06/2020.
//  Copyright © 2020 Lea Dukaez. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var categorySelected : Category? {
        didSet{
//            loadItems()
        }
    }

    var itemArray = [Item]()
    
    let alertError = UIAlertController(title: "Error", message: "Item can't be empty to be added", preferredStyle: .alert)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text == "" {
                self.showAlert()
            } else {
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
                self.tableView.reloadData()
                
//                self.saveItems()
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Alert Error when textField for new Item is Empty
    func showAlert() {
        self.present(alertError, animated: true) {
        // Enabling Interaction for Transperent Full Screen Overlay
        self.alertError.view.superview?.subviews.first?.isUserInteractionEnabled = true
        // Adding Tap Gesture to Overlay
        self.alertError.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
        }
    }
    
    @objc func actionSheetBackgroundTapped() {
        self.alertError.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
//    func saveItems() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
//        } catch {
//            print("Error encoding data \(error)")
//        }
//        tableView.reloadData()
//    }
//
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding data \(error)")
//            }
//        }
//    }
    

    
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // request items
    }
}
