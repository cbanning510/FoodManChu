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
    
    var controller: NSFetchedResultsController<Ingredient>!
    var ingredients: [Ingredient]?
    var recipeToEdit: Recipe?
    // recipeDetailsVC.recipeToEdit.ingredientList is list of ingredients
    weak var recipeDetailsVC: NewRecipeDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attemptIngredientFetch()
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true

        // Do any additional setup after loading the view.
    }
    
//    @IBAction func showrecipeToEditIngredientList(_ sender: UIBarButtonItem) {
//        guard let recipeToEdit = recipeToEdit else {
//            print("no recipe to edit!!!")
//            return 
//        }
//        print(recipeToEdit)
//        recipeDetailsVC?.recipeToEdit.ingredientList = ["salami"]
//    }
    

    
    func attemptIngredientFetch() {
        print("ingredient fetch!!")
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()
            ingredients = controller.sections![0].objects as? [Ingredient]
            print("\(ingredients!.count) ingredients")
            
            // call some func to check ingredients in recipeToEdit
        } catch let err {
            print(err)
        }
    }

}

extension IngredientsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // sections is a row of data:
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRows")
        if let sections = controller.sections {
            //print("sections: \(sections[0].objects)")
            let sectionInfo = sections[section]
            //print(sectionInfo.numberOfObjects)
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
            return UITableViewCell()
        }
        //print("form ingredient cell")
        configureCell(cell, indexPath: indexPath)
        return cell
    }    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    // replace with trailingswipeAction etc.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if let sections = controller.sections {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                ingredients?.remove(at: indexPath.row)
                Constants.context.delete(sections[0].objects![indexPath.row] as! Ingredient)
                Constants.ad.saveContext()
            }
            attemptIngredientFetch()
            tableView.endUpdates()
            tableView.reloadData()            
        }
    }
    
    func configureCell(_ cell: IngredientCell, indexPath: IndexPath) {
        let ingredient = controller.object(at: indexPath)
        cell.configCell(ingredient)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //print("didSelectRowAt")
//        if let objs = controller.fetchedObjects, objs.count > 0 { // objs return from fetch
//            //print("objs is: \(objs)")
//            let ingredient = objs[indexPath.row]
//            //print("recipe is: \(recipe)")
//            performSegue(withIdentifier: "DetailSegue", sender: recipe)
//        }
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DetailSegue" {
//            if let destination = segue.destination as? RecipeDetailsVC {
//                if let recipe = sender as? Recipe {
//                    print(recipe)
//                    destination.recipeToEdit = recipe
//                }
//            }
//        }
//    }
}
