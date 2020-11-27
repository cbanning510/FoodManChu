//
//  IngredientCell.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//

import UIKit

class IngredientCell: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func configCell(_ ingredient: Ingredient) {
        ingredientLabel.text = ingredient.name
        amountLabel.text = "1 cup"
        if let amount = ingredient.amount {
            amountLabel.text = amount
        }
        
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
