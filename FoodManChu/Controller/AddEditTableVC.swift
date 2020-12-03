//
//  AddEditTableVC.swift
//  FoodManChu
//
//  Created by chris on 12/1/20.
//

import UIKit

class AddEditTableVC: UITableViewController {
    
    var recipeToEdit: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("AddEditTableVC recipeToEdit! \(recipeToEdit!)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IngredientSegue" {
            if let destination = segue.destination as? IngredientsVC {
                destination.recipeToEdit = recipeToEdit
            }
        }
    }
}
