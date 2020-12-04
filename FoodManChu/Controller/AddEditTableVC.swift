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
    
    var recipeToEdit: Recipe?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Add EditTableVC viewDidAppear")
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("AddEditTable viewdidDisapear")
        resetIngredients()
        delegate?.modalDismissed(recipe: recipeToEdit!)
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
    
    func configureUI() {
       
        if (recipeToEdit?.ingredients?.count)! > 0 {
            addIngredientsLabel.text! = ""
            let ingredients = recipeToEdit?.ingredients as! Set<Ingredient>
            for i in ingredients {
                //print(i.name!)
                addIngredientsLabel.text! += "\(i.name!), "
            }
            
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
        print("\nkicked off \(viewController)")
        if viewController.isKind(of: RecipeDetailsVC.self) {
            print("holy crap")
//            for i in selectedIngredients {
//                recipeToEdit?.addToIngredients(i)
//            }
            (viewController as? RecipeDetailsVC)?.recipeToEdit = recipeToEdit
            
        }
    }
}


