//
//  InstructionsCell.swift
//  FoodManChu
//
//  Created by chris on 12/8/20.
//

import UIKit

class InstructionCell: UITableViewCell {

    @IBOutlet weak var instructionLabel: UILabel!
    var isCellSelected = false
    
    func configCell(_ instruction: Instruction) {
        instructionLabel.text = instruction.summary
    }

}
