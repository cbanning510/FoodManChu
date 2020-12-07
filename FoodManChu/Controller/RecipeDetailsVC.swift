//
//  RecipeDetails2VC.swift
//  FoodManChu
//
//  Created by chris on 12/1/20.
//

protocol ModalHandler {
    func modalDismissed(recipe: Recipe)
}

import UIKit

class RecipeDetailsVC: UIViewController {
    
    @IBOutlet weak var ingredientsUnderlineView: UIView!
    @IBOutlet weak var instructionsUnderlineView: UIView!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipeToEdit: Recipe?
    var isIngredientsSelected = true
    var recipeIngredients = [Ingredient]()
    var recipeInstructions = [Instruction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        recipeIngredients = (recipeToEdit!.ingredients?.allObjects as? [Ingredient])!
        recipeInstructions = (recipeToEdit!.instructions?.allObjects as? [Instruction])!
        instructionsUnderlineView.isHidden = true
        displayIngredientList()
        recipeImage.addBlackGradientLayerInBackground(frame: recipeImage.bounds, colors:[.clear, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6382170377)])
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self] (action) in
            Constants.context.delete(recipeToEdit!)
            do {
                try Constants.context.save()
                navigationController?.popViewController(animated: true)
            }
            catch {
                print(error)
            }
        })
        
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    func configureUI() {
        addBorder(view: ingredientsUnderlineView)
        addBorder(view: instructionsUnderlineView)
        recipeTitleLabel.text = recipeToEdit?.name
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEditTableSegue" {
            if let destVC = segue.destination as? UINavigationController,
                let targetController = destVC.topViewController as? AddEditTableVC {
                targetController.delegate = self
                targetController.recipeToEdit = recipeToEdit
            }
        }
    }
}

extension RecipeDetailsVC: ModalHandler {
    func modalDismissed (recipe: Recipe) {
        recipeToEdit = recipe
        recipeIngredients = (recipeToEdit!.ingredients?.allObjects as? [Ingredient])!
        displayIngredientList()
        configureUI()
    }
}

extension UIView{
    // image background gradient
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



