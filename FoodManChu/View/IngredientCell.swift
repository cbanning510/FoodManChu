//
//  IngredientCell.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//

import UIKit

class IngredientCell: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    var isCellSelected = false
    
    func configCell(_ ingredient: Ingredient) {
        ingredientLabel.text = ingredient.name
    }
}
