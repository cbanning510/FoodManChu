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
        //print("recipeToEdit at VDL in AddEditTableVC \(recipeToEdit!)")
        navigationController?.delegate = self
        if let recipeToEdit = recipeToEdit { // populate selectedIngredients with recipeToEdit ingredients
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
        print("Add EditTableVC viewDidAppear")
        // print("recipeToEdit in AddEditTavleVC\n \(recipeToEdit!)")
        print("selecctedIngredients recieved in AddEditTableVC:\n\(selectedIngredients)")
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //print("AddEditTable viewdidDisappear")
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
        //recipeNameTextField.text = recipeToEdit?.name
        // recipeDescriptionTextField.text = recipeToEdit?.summaryDescription
        if selectedIngredients.count > 0 {
            addIngredientsLabel.text = "" // reset to show following list
            let tempIngredients = selectedIngredients
            for i in tempIngredients {
                addIngredientsLabel.text! += "\(i.name!), "
            }
        } else {
            addIngredientsLabel.text = "Add Ingredients (Required)"
        }
        // scenario 1: clicking on EDIT, nav from RecipeDetails page, with ingredients already in recipe
        // 1) populate existing fields with recipeToEdit data
        //
        // scenario 2: after changes made in IngredientsVC, using back button
        
        //print("AddEdit configureUI!!!")
        //        if let name = tempRecipeName {
        //            recipeNameTextField.text = name
        //        } else {
        //            recipeNameTextField.text = recipeToEdit?.name
        //        }
        //        if let description = tempSummaryDescription {
        //            recipeDescriptionTextField.text = description
        //        } else {
        //            recipeDescriptionTextField.text = recipeToEdit?.summaryDescription
        //        }
        
        // if selectedIngredients.count == 0 { // if when coming back from IngredientVC, none are selected, or if newRecipe, or if newly editeding recipe
        // print("selectedIngredients.count should be 0:  \(selectedIngredients.count)")
        // if let recipeToEdit = recipeToEdit { // if it's an existing recipe being edited
        
        //                if let ingredients = recipeToEdit.ingredients { // if ingredients exist in recipe being edited
        //
        //                    if ingredients.count > 0 { // populate addIngredients label with recipeToEdit ingredients
        //                        addIngredientsLabel.text! = ""
        //                        let ingredientsCopy = recipeToEdit.ingredients as! Set<Ingredient>
        //
        //                        for i in ingredientsCopy {
        //                            //print(i.name!)
        //                            addIngredientsLabel.text! += "\(i.name!), "
        //                        }
        //                    }
        //
        //                }
        
        // }
        
        //        } else {
        //            print("selectedIngredients count in configureUI:\n  \(selectedIngredients.count)")
        //            addIngredientsLabel.text! = ""
        //            for i in selectedIngredients {
        //                addIngredientsLabel.text! += "\(i.name!), "
        //            }
        //        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("save! salectedIngredients count is: \(selectedIngredients.count)")
        if isNewRecipe {
            print("newREcipe")
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
            print("oldREcipe")
            print("selected Ingredients count\n\(selectedIngredients.count)")
            print("recipeToEdit ingredient count: \(recipeToEdit!.ingredients!.count)")
            recipeToEdit?.summaryDescription = recipeDescriptionTextField.text!
            recipeToEdit?.name = recipeNameTextField.text!
            // clear out recipeToEdit ingredienets? recipeToEdit.r
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
        //print("\nkicked off \(viewController)")
        if viewController.isKind(of: RecipeDetailsVC.self) {
            //print("holy crap")
            //            for i in selectedIngredients {
            //                recipeToEdit?.addToIngredients(i)
            //            }
            (viewController as? RecipeDetailsVC)?.recipeToEdit = recipeToEdit
            
        }
    }
}


