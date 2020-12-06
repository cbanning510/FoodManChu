//
//  AddEditTableVC.swift
//  FoodManChu
//
//  Created by chris on 12/1/20.
//

import UIKit
import CoreData

class AddEditTableVC: UITableViewController {
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var recipeDescriptionTextField: UITextField!
    
    @IBOutlet weak var addIngredientsLabel: UILabel!
    @IBOutlet weak var addInstructionsLabel: UILabel!
    
    var ingredientsToReset = [Ingredient]()
    var previousVC = RecipeDetailsVC()
    var delegate: ModalHandler?
    var newRecipeAddDelegate: newRecipeModalHandler?
    var recipeToEdit: Recipe?
    var recipeUnchanged: Recipe?
    var selectedIngredients = [Ingredient]()
    var tempRecipeName: String?
    var tempSummaryDescription: String?
    var isNewRecipe = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        if let recipeToEdit = recipeToEdit { // populate 'selectedIngredients' var with recipeToEdit ingredients
            if let ingredients = recipeToEdit.ingredients {
                for i in ingredients {
                    selectedIngredients.append(i as! Ingredient)
                }
            }
        }
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetIngredients()
        if let recipeToEdit = recipeToEdit {
            delegate?.modalDismissed(recipe: recipeToEdit)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "IngredientSegue" {
            if let destination = segue.destination as? IngredientsVC {
                tempSummaryDescription = recipeDescriptionTextField.text! // hold changes to text fields
                tempRecipeName = recipeNameTextField.text!
                
                destination.recipeToEdit = recipeToEdit
                destination.selectedIngredients = selectedIngredients
            }
        }
    }
    
    func configureUI() {
        
        if let name = tempRecipeName {
            recipeNameTextField.text = name
        } else {
            recipeNameTextField.text = recipeToEdit?.name
        }
        if let description = tempSummaryDescription {
            recipeDescriptionTextField.text = description
        } else {
            recipeDescriptionTextField.text = recipeToEdit?.summaryDescription
        }
        
        if selectedIngredients.count > 0 {
            addIngredientsLabel.text = "" // reset to show following list
            let tempIngredients = selectedIngredients
            for i in tempIngredients {
                addIngredientsLabel.text! += "\(i.name!), "
            }
        } else {
            addIngredientsLabel.text = "Add Ingredients (Required)"
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if isNewRecipe {
            let recipe = Recipe(context: Constants.context)
            recipe.summaryDescription = recipeDescriptionTextField.text!
            recipe.name = recipeNameTextField.text
            for i in selectedIngredients {
                recipe.addToIngredients(i)
            }
            
            do {
                try Constants.context.save()
                newRecipeAddDelegate?.dismissModal()
            }
            catch {
                print(error)
            }
            self.dismiss(animated: true, completion: nil)
            
        } else  {
            
            recipeToEdit?.summaryDescription = recipeDescriptionTextField.text!
            recipeToEdit?.name = recipeNameTextField.text!
            // clear out recipeToEdit ingredients
            recipeToEdit?.ingredients = nil
            
            for i in selectedIngredients {
                recipeToEdit?.addToIngredients(i)
            }
            do {
                try Constants.context.save()
            }
            catch {
                print(error)
            }
            self.dismiss(animated: true, completion: nil)
        }       
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        recipeToEdit = recipeUnchanged
        do {
            try Constants.context.save()
        }
        catch {
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetIngredients() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        do {
            ingredientsToReset = try Constants.context.fetch(fetchRequest)
            //reset here
            for i in ingredientsToReset {
                i.isCellSelected = false
            }
            do {
                try Constants.context.save()
                previousVC.recipeToEdit = recipeToEdit
            }
            catch {
                print(error)
            }
        } catch let err {
            print(err)
        }
    }
}

extension AddEditTableVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController.isKind(of: RecipeDetailsVC.self) {
            (viewController as? RecipeDetailsVC)?.recipeToEdit = recipeToEdit
        }
    }
}


