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
    //var newRecipeAdddelegate: ModalHandler?
    var recipeToEdit: Recipe?
    var recipeUnchanged: Recipe?
    var selectedIngredients = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("recipeToEdit at VDL in AddEditTableVC \(recipeToEdit!)")
        navigationController?.delegate = self
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Add EditTableVC viewDidAppear")
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //print("AddEditTable viewdidDisappear")
        resetIngredients()
        if let recipeToEdit = recipeToEdit {
            delegate?.modalDismissed(recipe: recipeToEdit)
        }
    }
    
    func configureUI() {
        print("AddEdit configureUI!!!")
        recipeNameTextField.text = recipeToEdit?.name
        recipeDescriptionTextField.text = recipeToEdit?.summaryDescription
        if selectedIngredients.count == 0 {
            if let recipeToEdit = recipeToEdit {
                
            if let ingredients = recipeToEdit.ingredients {
                if ingredients.count > 0 {
                    addIngredientsLabel.text! = ""
                    let ingredients = recipeToEdit.ingredients as! Set<Ingredient>
                    for i in ingredients {
                        //print(i.name!)
                        addIngredientsLabel.text! += "\(i.name!), "
                    }
                }
            }
        }
//            if (recipeToEdit?.ingredients?.count)! > 0 {
//                addIngredientsLabel.text! = ""
//                let ingredients = recipeToEdit?.ingredients as! Set<Ingredient>
//                for i in ingredients {
//                    //print(i.name!)
//                    addIngredientsLabel.text! += "\(i.name!), "
//                }
//            }
        } else {
            addIngredientsLabel.text! = ""
            for i in selectedIngredients {
                addIngredientsLabel.text! += "\(i.name!), "
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print(":save button pressed recipeToEdit is \(recipeToEdit!)")
        recipeToEdit?.summaryDescription = recipeDescriptionTextField.text
        recipeToEdit?.name = recipeNameTextField.text
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IngredientSegue" {
            if let destination = segue.destination as? IngredientsVC {
                destination.recipeToEdit = recipeToEdit
            }
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


