//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//

import UIKit
import CoreData

class IngredientsVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var AddEditVC: AddEditTableVC?
    var ingredients: [Ingredient]?
    var selectedIngredients = [Ingredient]()
    var recipeToEdit: Recipe?
    weak var recipeDetailsVC: RecipeDetailsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.delegate = self
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        attemptIngredientFetch()
        setSelectedIngredients()
    }
    
    func setSelectedIngredients() {
        for i in ingredients! {
            if selectedIngredients.contains(i) {
                i.isCellSelected = true
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Ingredient", message: "Ingredient name?", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            let newIngredient = Ingredient(context: Constants.context)
            newIngredient.name = textField.text
            
            do {
                try Constants.context.save()
            }
            catch {
                print(error)
            }
            self.attemptIngredientFetch()
        }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func attemptIngredientFetch() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            self.ingredients = try Constants.context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let err {
            print(err)
        }
    }
}

extension IngredientsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
                return UITableViewCell()
            }
            let ingredient = ingredients![indexPath.row]
            cell.configCell(ingredient)
            
            if selectedIngredients.contains(ingredient) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setSelectedIngredients()
        let ingredient = ingredients![indexPath.row]
        ingredient.isCellSelected.toggle()
        
        if ingredient.isCellSelected {
            selectedIngredients.append(ingredient)
        } else {
            for (index, element) in selectedIngredients.enumerated() {
                if element.name == ingredient.name {
                    selectedIngredients.remove(at: index)
                }
            }            
        }
        tableView.reloadRows(at:[indexPath],with:.none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let ingredientToRemove = self.ingredients![indexPath.row]
            if self.selectedIngredients.contains(ingredientToRemove) {
                for (index, element) in self.selectedIngredients.enumerated() {
                    if element.name == ingredientToRemove.name {
                        self.selectedIngredients.remove(at: index)
                        self.recipeToEdit?.removeFromIngredients(element)
                    }
                }
            }
            Constants.context.delete(ingredientToRemove)            
            
            do {
                try Constants.context.save()
            }
            catch {
                print(error)
            }
            self.attemptIngredientFetch()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let ingredientToEdit = self.ingredients![indexPath.row]
            
            let alert = UIAlertController(title: "Edit Ingredient", message: "Edit Ingredient:", preferredStyle: .alert)
            alert.addTextField()
            let textField = alert.textFields![0]
            textField.text = ingredientToEdit.name
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                let textfield = alert.textFields![0]
                ingredientToEdit.name = textfield.text
                
                do {
                    try Constants.context.save()
                }
                catch {
                    print(error)
                }
                self.attemptIngredientFetch()
            }
            alert.addAction(saveButton)
            self.present(alert, animated: true, completion: nil)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension IngredientsVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: AddEditTableVC.self) {
            (viewController as? AddEditTableVC)?.selectedIngredients = selectedIngredients
        }
    }
}




