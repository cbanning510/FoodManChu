//
//  RecipeDetailsVC.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//

import UIKit
import CoreData

class RecipeDetailsVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var categoryTypeLabel: UILabel!
    @IBOutlet weak var summaryTextField: UITextField!
    
    //@IBOutlet weak var categoryPicker: UIPickerView!
    
    //var controller: NSFetchedResultsController<Ingredient>!
    var recipeToEdit: Recipe!
    var categories = [Category]()
    var pickerData: [String] = [String]()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configureUI
        recipeNameTextField.text = recipeToEdit.name
        prepTimeTextField.text = String(recipeToEdit.prepTime)
        categoryTextField.text = recipeToEdit.categoryType!
        // populate Recipe
        fetchCategories()
        populateCategoryPicker()
        configurecategoryTypePicker()        
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
       // show borders around all textFields
        //make categoryType tappable
        // activate all textFields
        categoryTextField.isUserInteractionEnabled = true
    }
    
    func configurecategoryTypePicker() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
        categoryTextField.addGestureRecognizer(tap)
        categoryTextField.isUserInteractionEnabled = false
    }
    
    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = false
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        view.addSubview(picker)
                
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        categoryTextField.isUserInteractionEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue!!!!!!")
        if segue.identifier == "IngredientsSegue" {
            if let destination = segue.destination as? IngredientsVC {
                print("holy fuck! \(recipeToEdit!)")
                destination.recipeToEdit = recipeToEdit
            }
        }
    }
    
    func fetchCategories() {
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        do {
            self.categories = try Constants.context.fetch(request)
        } catch let err {
            print(err)
        }
    }
    
    func populateCategoryPicker() {
        for category in categories {
            pickerData.append(category.name!)
        }
    }
    
    @IBAction func listIngredientsButton(_ sender: UIButton) {
        //print(controller.fetchedObjects!)
    }
}

extension RecipeDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("didSelect")
        categoryTextField.text = pickerData[row]
        //picker.isHidden = true
    }
    
}


