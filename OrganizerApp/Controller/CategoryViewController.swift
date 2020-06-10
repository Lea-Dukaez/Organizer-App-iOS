//
//  CategoryViewController.swift
//  OrganizerApp
//
//  Created by Léa on 09/06/2020.
//  Copyright © 2020 Lea Dukaez. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    let alertError = UIAlertController(title: "Error", message: "Category name can't be empty to be added", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        let bar = UINavigationBarAppearance()
        bar.configureWithOpaqueBackground()
        bar.backgroundColor = UIColor(hexString: "E66767")
        bar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navBar.standardAppearance = bar
        navBar.compactAppearance = bar
        navBar.scrollEdgeAppearance = bar
        navBar.tintColor = ContrastColorOf(UIColor(hexString: "E66767")!, returnFlat: true)

    }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let caterogyColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = caterogyColor
            cell.textLabel?.textColor = ContrastColorOf(caterogyColor, returnFlat: true)
            
        } else {
            cell.textLabel?.text = "No Categaries added yet"
        }

        return cell 
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let itemsVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                itemsVC.categorySelected = categories?[indexPath.row]
            }
        }
    }

    // MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text == "" {
                self.showAlert() 
            } else {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = RandomFlatColorWithShade(.light).hexValue()
                self.save(category: newCategory)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Error Alert when textField for new Category is Empty
    
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
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error updating item's done status: \(error)")
            }
        }
    }
}
  
