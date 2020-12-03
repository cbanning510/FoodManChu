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
        attemptIngredientFetch()
        selectedIngredients = recipeToEdit?.ingredients?.allObjects as! [Ingredient]
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //print("selectedIngredients: \(selectedIngredients)")
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
        cell.accessoryType = ingredients![indexPath.row].isCellSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients![indexPath.row]
        selectedIngredients.append(ingredient)
        ingredient.isCellSelected.toggle()
        tableView.reloadRows(at:[indexPath],with:.none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let ingredientToRemove = self.ingredients![indexPath.row]
            Constants.context.delete(ingredientToRemove)
            
            do {
                try Constants.context.save()
            }
            catch {
                
            }
            self.attemptIngredientFetch()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
    

