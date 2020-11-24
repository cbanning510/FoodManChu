//
//  RecipeDetailsVC.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//

import UIKit

class RecipeDetailsVC: UIViewController {

    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var recipeToEdit: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeNameLabel.text = recipeToEdit.name
        prepTimeLabel.text = "\(String(recipeToEdit.prepTime)) minutes"
        categoryLabel.text = recipeToEdit.categoryType
        
        
        
        
        //ingredientsLabel.text = recipeToEdit.ingredients
        //instructionsLabel.text = recipeToEdit.cookingInstructions
        
        
        

    }

}
