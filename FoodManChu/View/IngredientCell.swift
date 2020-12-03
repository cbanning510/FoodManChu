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
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .none
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        self.accessoryType = selected ? .checkmark : .none
//    }
    
}
