//
//  RecipeCell.swift
//  FoodManChu
//
//  Created by chris on 11/23/20.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var prepTime: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var category: UILabel!
    
    func configCell(_ recipe: Recipe) {
        name.text = recipe.name
        let prepTimeString = String(recipe.prepTime)
        prepTime.text = "prep time: \(prepTimeString) min"
        summary.text = recipe.summaryDescription
        category.text = recipe.categoryType
        if let image = recipe.image {
            thumb.image = UIImage(data: image)
        }
    }
}
