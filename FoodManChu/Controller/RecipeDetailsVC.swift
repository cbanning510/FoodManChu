////
////  RecipeDetailsVC.swift
////  FoodManChu
////
////  Created by chris on 11/24/20.
////
//
//import UIKit
//import CoreData
//
//class RecipeDetailsVC: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
//    
//    //@IBOutlet weak var selectedIngredientLabel: UILabel!
//    @IBOutlet weak var recipeImage: UIImageView!
//    //@IBOutlet weak var categoryTextField: UITextField!
//   // @IBOutlet weak var recipeNameTextField: UITextField!
//   // @IBOutlet weak var prepTimeTextField: UITextField!
//   // @IBOutlet weak var categoryTypeLabel: UILabel!
//   // @IBOutlet weak var summaryTextField: UITextField!
//   // @IBOutlet weak var ingredientsTableView: UITableView!
//    
//    //@IBOutlet weak var categoryPicker: UIPickerView!
//    
//    //var controller: NSFetchedResultsController<Ingredient>!
//    var recipeToEdit: Recipe?
//    var recipeIngredients: [Ingredient]?
//    var categories: [Category]?
//    var ingredients: [Ingredient]?
//    var selectedIngredients: [Ingredient]?
//    var categoryPickerData: [String] = [String]()
//    var ingredientPickerData: [String] = [String]()
//    var toolBar = UIToolbar()
//    var categoryPicker  = UIPickerView()
//    var ingredientPicker = UIPickerView()
//    var isPickerVisible = false
//    var selectedPicker = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        ingredientsTableView.delegate = self
//        ingredientsTableView.dataSource = self
//        categoryPicker.delegate = self
//        categoryPicker.dataSource = self
//        ingredientPicker.delegate = self
//        ingredientPicker.dataSource = self
//        configureUI()
//        // populate Recipe
//        fetchCategories()
//        // populateCategoryPicker()
//        createTapGestureForCategoryPicker()
//        //disableTextFields()
//        // get ingredients for Recipe:
//        attemptIngredientFetch()
//        populateIngredientPIcker()
//        enableTextFields()

//
//    }
//    
//    func configureUI() {
//        // configureUI
//        //recipeNameTextField.text = recipeToEdit!.name
//        prepTimeTextField.text = String(recipeToEdit!.prepTime)
//        categoryTextField.text = recipeToEdit?.categoryType!
//        recipeIngredients = recipeToEdit!.ingredients?.allObjects as? [Ingredient]
//        ingredientsTableView.layer.borderColor = UIColor.gray.cgColor
//        ingredientsTableView.layer.borderWidth = 3.0
//    }
//    
//    @IBAction func addIngredientBtnPressed(_ sender: UIButton) {
//        // configure picker for ingredient list
//        if !self.isPickerVisible {
//            selectedPicker = "ingredient"
//            //populateIngredientPIcker()
//            self.isPickerVisible = true
//            //disableTextFields()
//            ingredientPicker.isHidden = false
//            ingredientPicker.backgroundColor = UIColor.white
//            ingredientPicker.setValue(UIColor.black, forKey: "textColor")
//            ingredientPicker.autoresizingMask = .flexibleWidth
//            ingredientPicker.contentMode = .center
//            ingredientPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
//            view.addSubview(ingredientPicker)
//                    
//            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//            toolBar.barStyle = .default
//            toolBar.isTranslucent = true
//            toolBar.sizeToFit()
//            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
//            view.addSubview(toolBar)
//        }
//    }
//    
//    func attemptIngredientFetch() {
//        let request = Ingredient.fetchRequest() as NSFetchRequest<Ingredient>
//        let nameSort = NSSortDescriptor(key: "name", ascending: true)
//        request.sortDescriptors = [nameSort]
//        
//        do {
//            self.ingredients = try Constants.context.fetch(request)
//        } catch let err {
//            print(err)
//        }
//    }
//    
//    func enableTextFields() {
//        categoryTextField.isUserInteractionEnabled = true
//        //recipeNameTextField.isUserInteractionEnabled = true
//        prepTimeTextField.isUserInteractionEnabled = true
//        summaryTextField.isUserInteractionEnabled = true
//    }
//    func disableTextFields() {
//        categoryTextField.isUserInteractionEnabled = false
//        //recipeNameTextField.isUserInteractionEnabled = false
//        prepTimeTextField.isUserInteractionEnabled = false
//        summaryTextField.isUserInteractionEnabled = false
//    }
//    
//    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
//        //enableTextFields()
//    }
//    
//    func createTapGestureForCategoryPicker() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
//        categoryTextField.addGestureRecognizer(tap)
//        categoryTextField.isUserInteractionEnabled = false
//    }
//    
//    
//    
//    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
//        if !self.isPickerVisible {
//            populateCategoryPicker()
//            selectedPicker = "categories"
//            self.isPickerVisible = true
//            disableTextFields()
//            categoryPicker.isHidden = false
//            categoryPicker.backgroundColor = UIColor.white
//            categoryPicker.setValue(UIColor.black, forKey: "textColor")
//            categoryPicker.autoresizingMask = .flexibleWidth
//            categoryPicker.contentMode = .center
//            categoryPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
//            view.addSubview(categoryPicker)
//                    
//            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//            toolBar.barStyle = .default
//            toolBar.isTranslucent = true
//            toolBar.sizeToFit()
//            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
//            view.addSubview(toolBar)
//        }
//    }
//    
//    @objc func onDoneButtonTapped() {
//        toolBar.removeFromSuperview()
//        categoryPicker.removeFromSuperview()
//        ingredientPicker.removeFromSuperview()
//        isPickerVisible = false
//        selectedPicker = ""
//        //ingredientPickerData.removeAll()
//        //categoryPickerData.removeAll()
//        enableTextFields()
//        configureUI()
//        ingredientsTableView.reloadData()
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "IngredientsSegue" {
//            if let destination = segue.destination as? IngredientsVC {
//                destination.recipeToEdit = recipeToEdit
//            }
//        }
//    }
//    
//    func fetchCategories() {
//        let request = Category.fetchRequest() as NSFetchRequest<Category>
//        do {
//            self.categories = try Constants.context.fetch(request)
//        } catch let err {
//            print(err)
//        }
//    }
//    
//    func populateIngredientPIcker() {
//        for ingredient in ingredients! {
//            ingredientPickerData.append(ingredient.name!)
//        }
//    }
//    
//    func populateCategoryPicker() {
//        for category in categories! {
//            categoryPickerData.append(category.name!)
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return recipeIngredients!.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
//            return UITableViewCell()
//        }
//        let ingredient = recipeIngredients![indexPath.row]
//        //configureCell(cell, indexPath: indexPath)
//        cell.configCell(ingredient)
//        return cell
//    }
//}
//
//extension RecipeDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if selectedPicker == "ingredient" {
//            return ingredientPickerData.count
//        } else {
//            return categoryPickerData.count
//        }
//        
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if selectedPicker == "ingredient" {
//            return ingredientPickerData[row]
//        } else {
//            return categoryPickerData[row]
//        }
//    }
//    
//    func save() {
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//    }
//    
//    // Capture the picker view selection
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if selectedPicker == "ingredient" {
//            for ingredient in self.ingredients! {
//                if ingredient.name == ingredientPickerData[row] {
//                    
//                    ingredient.amount = "4 cups"
//                   
//                    recipeIngredients!.append(ingredient)
//                    recipeToEdit!.addToIngredients(ingredient)
//                }
//            }
//        } else {
//            recipeToEdit!.categoryType = categoryPickerData[row]
//        }
//        do {
//            try Constants.context.save()
//            ingredientsTableView.reloadData()
//        } catch let err {
//            print(err)
//        }
//    }
//    
//}
//
//extension UITextField{
//    
//    @IBInspectable var doneAccessory: Bool{
//        get{
//            return self.doneAccessory
//        }
//        set (hasDone) {
//            if hasDone{
//                addDoneButtonOnKeyboard()
//            }
//        }
//    }
//    
//    func addDoneButtonOnKeyboard()
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//        
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//        
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//        
//        self.inputAccessoryView = doneToolbar
//    }
//    
//    @objc func doneButtonAction()
//    {
//        self.resignFirstResponder()
//    }
//}
//

