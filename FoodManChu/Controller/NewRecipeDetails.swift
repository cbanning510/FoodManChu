//
//  RecipeDetails2VC.swift
//  FoodManChu
//
//  Created by chris on 12/1/20.
//

import UIKit

class NewRecipeDetails: UIViewController {
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var listLabel: UILabel!
    
    @IBOutlet weak var instructionsUnderlineView: UIView!
    @IBOutlet weak var ingredientsUnderlineView: UIView!
    
    var recipeToEdit: Recipe?
    var isIngredientsSelected = true
    var recipeIngredients = [Ingredient]()
    var recipeInstructions = [Instruction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        recipeIngredients = (recipeToEdit!.ingredients?.allObjects as? [Ingredient])!
        //recipeToEdit?.instructions.
        recipeInstructions = (recipeToEdit!.instructions?.allObjects as? [Instruction])!
        instructionsUnderlineView.isHidden = true
        displayIngredientList()
    }
    
    func configureUI() {
        recipeImage.addBlackGradientLayerInBackground(frame: recipeImage.bounds, colors:[.clear, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.747270976)])
        ingredientsUnderlineView.addBorder(toSide: .Bottom, withColor: UIColor.red.cgColor, andThickness: 44.0)
        addBorder(view: ingredientsUnderlineView)
        addBorder(view: instructionsUnderlineView)
        
    }
    
    func displayIngredientList() {
        var ingredientList = String()
        for ingredient in recipeIngredients {
            ingredientList += ingredient.name! + "\n"
        }
        listLabel.text = ingredientList
    }
    
    func displayInstructionList() {
        var instructionList = String()
        for instruction in recipeInstructions {
            instructionList += instruction.summary! + "\n"
        }
        listLabel.text = instructionList
    }
    
    func addBorder(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        print("edit")
    }
    
    @IBAction func ingredientsButtonPressed(_ sender: UIButton) {
        isIngredientsSelected = true
        ingredientsUnderlineView.isHidden = false
        instructionsUnderlineView.isHidden = true
        displayIngredientList()
    }
    
    @IBAction func instructionsButtonPressed(_ sender: UIButton) {
        isIngredientsSelected = false
        ingredientsUnderlineView.isHidden = true
        instructionsUnderlineView.isHidden = false
        displayInstructionList()
    }
 
}

extension UIView{
    // For insert layer in Foreground
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
        print(frame)
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        gradient.startPoint = CGPoint(x: 0, y: 0.7)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        self.layer.addSublayer(gradient)
    }
    // For insert layer in background
    func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        gradient.startPoint = CGPoint(x: 0, y: 0.7)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {

    enum ViewSide {
           case Left, Right, Top, Bottom
       }

       func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

           let border = CALayer()
           border.backgroundColor = color

           switch side {
           case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
           case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
           case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
           case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
           }

           layer.addSublayer(border)
       }
}


