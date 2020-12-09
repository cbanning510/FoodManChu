//
//  AddEditTableVC.swift
//  FoodManChu
//
//  Created by chris on 12/1/20.
//

import UIKit
import CoreData

class AddEditTableVC: UITableViewController  {
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var recipeDescriptionTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addIngredientsLabel: UILabel!
    @IBOutlet weak var addInstructionsLabel: UILabel!
    @IBOutlet weak var addIngredientsCell: UITableViewCell!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    var categories: [Category]?
    var categoryPicker  = UIPickerView()
    var categoryPickerData: [String] = [String]()
    var delegate: ModalHandler?
    var ingredientsToReset = [Ingredient]()
    var instructionsToReset = [Instruction]()
    var isNewRecipe = false
    var isPickerVisible = false
    var newRecipeAddDelegate: newRecipeModalHandler?
    var previousVC = RecipeDetailsVC()
    var recipeToEdit: Recipe?
    var recipeUnchanged: Recipe?
    var selectedIngredients = [Ingredient]()
    var selectedInstructions = [Instruction]()
    var tempInstructions: [Instruction]?
    var tempCategory: String?
    var tempPrepTime: String?
    var tempRecipeName: String?
    var tempSummaryDescription: String?
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        populateSelectedIngredients()
        populateSelectedInstructions()
        createTapGestureForCategoryPicker()
        configureUI()
        fetchCategories()
        prepTimeTextField.delegate = self
    }
    
    @IBAction func setPicture(_ sender: Any) {
        self.openImagePicker()
    }
    @IBAction func copyButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Copy Recipe", message: "Duplicate Recipe?", preferredStyle: .alert)
        let saveButton = UIAlertAction(title: "Copy", style: .default) { (action) in
            let newRecipe = self.recipeToEdit!.copyEntireObjectGraph(context: Constants.context)
            do {
                try Constants.context.save()
                self.performSegue(withIdentifier: "HomePageSegue", sender: nil)
            }
            catch {
                print(error)
            }
        }
        alert.addAction(saveButton)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func populateSelectedIngredients() {
        if let recipeToEdit = recipeToEdit { // populate 'selectedIngredients' var with recipeToEdit ingredients
            if let ingredients = recipeToEdit.ingredients {
                for i in ingredients {
                    selectedIngredients.append(i as! Ingredient)
                }
            }
        }
    }
    
    func populateSelectedInstructions() {
        if let recipeToEdit = recipeToEdit { // populate 'selectedInstructions' var with recipeToEdit ingredients
            if let instructions = recipeToEdit.instructions {
                for i in instructions {
                    selectedInstructions.append(i as! Instruction)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetIngredients()
        if let recipeToEdit = recipeToEdit {
            delegate?.modalDismissed(recipe: recipeToEdit)
        }
    }
    
    func populateCategoryPicker() {
        for category in categories! {
            categoryPickerData.append(category.name!)
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
    
    func enableTextFields() {
        prepTimeTextField.isUserInteractionEnabled = true
        recipeNameTextField.isUserInteractionEnabled = true
        recipeDescriptionTextField.isUserInteractionEnabled = true
        addIngredientsCell.isUserInteractionEnabled = true
    }
    func disableTextFields() {
        prepTimeTextField.isUserInteractionEnabled = false
        recipeNameTextField.isUserInteractionEnabled = false
        recipeDescriptionTextField.isUserInteractionEnabled = false
        addIngredientsCell.isUserInteractionEnabled = false
    }
    
    func createTapGestureForCategoryPicker() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
        categoryTextField.addGestureRecognizer(tap)
        categoryTextField.isUserInteractionEnabled = true
    }
    
    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
        if !self.isPickerVisible {
            populateCategoryPicker()
            self.isPickerVisible = true
            // save data to temp vars before disabling
            tempSummaryDescription = recipeDescriptionTextField.text! // hold changes to text fields
            tempRecipeName = recipeNameTextField.text!
            tempPrepTime = prepTimeTextField.text
            disableTextFields()
            categoryPicker.isHidden = false
            categoryPicker.backgroundColor = UIColor.white
            categoryPicker.setValue(UIColor.black, forKey: "textColor")
            categoryPicker.autoresizingMask = .flexibleWidth
            categoryPicker.contentMode = .center
            categoryPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            view.addSubview(categoryPicker)
            
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.sizeToFit()
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            view.addSubview(toolBar)
        }
    }
    
    @objc func onDoneButtonTapped() {
        if isNewRecipe {
            tempSummaryDescription = recipeDescriptionTextField.text! // hold changes to text fields
            tempRecipeName = recipeNameTextField.text!
            tempPrepTime = prepTimeTextField.text
        }
        toolBar.removeFromSuperview()
        categoryPicker.removeFromSuperview()
        isPickerVisible = false
        enableTextFields()
        configureUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IngredientSegue" {
            if let destination = segue.destination as? IngredientsVC {
                tempSummaryDescription = recipeDescriptionTextField.text! // hold changes to text fields
                tempRecipeName = recipeNameTextField.text!
                tempPrepTime = prepTimeTextField.text
                destination.recipeToEdit = recipeToEdit
                destination.selectedIngredients = selectedIngredients
            }
        }
        if segue.identifier == "InstructionSegue" {
            if let destination = segue.destination as? InstructionsVC {
                tempSummaryDescription = recipeDescriptionTextField.text! // hold changes to text fields
                tempRecipeName = recipeNameTextField.text!
                tempPrepTime = prepTimeTextField.text
                destination.recipeToEdit = recipeToEdit
                destination.selectedInstructions = selectedInstructions
            }
        }
    }
    
    func configureUI() {
        if let name = tempRecipeName {
            recipeNameTextField.text = name
        } else {
            recipeNameTextField.text = recipeToEdit?.name
        }
        
        if let description = tempSummaryDescription {
            recipeDescriptionTextField.text = description
        } else {
            recipeDescriptionTextField.text = recipeToEdit?.summaryDescription
        }
        if !isNewRecipe {
            if let image = recipeToEdit!.image {
                imageView.image = UIImage(data: image)
            }
        }
        
        if let category = tempCategory {
            categoryTextField.text = category
        } else {
            categoryTextField.text = recipeToEdit?.categoryType
        }
        
        if let prepTime = tempPrepTime {
            prepTimeTextField.text = prepTime
        } else {
            if let prepTime = recipeToEdit?.prepTime {
                prepTimeTextField.text = String(prepTime)
            }
        }
        
        if selectedIngredients.count > 0 {
            addIngredientsLabel.text = "" // reset to show following list
            let tempIngredients = selectedIngredients
            for i in tempIngredients {
                addIngredientsLabel.text! += "\(i.name!), "
            }
        } else {
            addIngredientsLabel.text = "Add Ingredients (Required)"
        }
        
        if let instructions = tempInstructions {
            if instructions.count > 0 {
                addInstructionsLabel.text = "" // reset to show following list
                for i in tempInstructions! {
                    if let summary = i.summary {
                        addInstructionsLabel.text! += "\(summary),"
                    }
                }
            }
            
        } else if selectedInstructions.count > 0 {
            addInstructionsLabel.text = "" // reset to show following list
            let tempInstructions = selectedInstructions
            for i in tempInstructions {
                if let summary = i.summary {
                    addInstructionsLabel.text! += "\(summary),"
                }
            }
        } else {
            addInstructionsLabel.text = "Add Instructions (Required)"
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill out required fields", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if recipeNameTextField.text!.count < 2 || addIngredientsLabel.text == "Add Ingredients (Required)" || addInstructionsLabel.text == "Add Instructions (Required)" {
            showAlert()
            return
        }
        
        if isNewRecipe {
            let recipe = Recipe(context: Constants.context)
            if let image = imageView.image {
                let png = image.pngData()
                recipe.image = png
            }
            
            recipe.categoryType = tempCategory
            recipe.summaryDescription = recipeDescriptionTextField.text!
            recipe.name = recipeNameTextField.text
            if let time = prepTimeTextField.text {
                recipe.prepTime = Int64(time) ?? 0
            }
            
            for i in selectedIngredients {
                recipe.addToIngredients(i)
            }
            
            if let instructions = tempInstructions {
                if instructions.count > 0 {
                    recipe.instructions = nil // reset instructions
                    for i in tempInstructions! {
                        recipe.addToInstructions(i)
                    }
                }
            } 
            
            do {
                try Constants.context.save()
                //newRecipeAddDelegate?.dismissModal()
            }
            catch {
                print(error)
            }
            self.performSegue(withIdentifier: "HomePageSegue", sender: nil)
        } else  {
            
            if let image = imageView.image {
                let png = image.pngData()
                recipeToEdit?.image = png
            }
            
            recipeToEdit?.summaryDescription = recipeDescriptionTextField.text!
            recipeToEdit?.name = recipeNameTextField.text!
            recipeToEdit?.categoryType = tempCategory
            if let time = prepTimeTextField.text {
                recipeToEdit?.prepTime = Int64(time) ?? 0
            }
            // clear out recipeToEdit ingredients
            recipeToEdit?.ingredients = nil
            
            for i in selectedIngredients {
                recipeToEdit?.addToIngredients(i)
            }
            
            if let instructions = tempInstructions {
                if instructions.count > 0 {
                    recipeToEdit?.instructions = nil // reset instructions
                    for i in tempInstructions! {
                        recipeToEdit?.addToInstructions(i)
                    }
                }
            } else {
                for i in selectedInstructions {
                    recipeToEdit?.addToInstructions(i)
                }
            }
            
            
            do {
                try Constants.context.save()
            }
            catch {
                print(error)
            }
            self.performSegue(withIdentifier: "HomePageSegue", sender: nil)
        }       
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.modalDismissed(recipe: recipeToEdit!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetIngredients() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        do {
            ingredientsToReset = try Constants.context.fetch(fetchRequest)
            
            for i in ingredientsToReset {
                i.isCellSelected = false
            }
            do {
                try Constants.context.save()
                previousVC.recipeToEdit = recipeToEdit
            }
            catch {
                print(error)
            }
        } catch let err {
            print(err)
        }
    }
}

extension AddEditTableVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: RecipeDetailsVC.self) {
            print("leaving AddEditTableVC for RecipeDetails!")
            (viewController as? RecipeDetailsVC)?.recipeToEdit = recipeToEdit
        }
    }
}

extension AddEditTableVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerData[row]
    }
    
    func save() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categoryPickerData[row]
        tempCategory = categoryPickerData[row]
    }
}

extension AddEditTableVC: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard NSCharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
}

extension AddEditTableVC: UIImagePickerControllerDelegate {
    func openImagePicker() {
        print("openImagePicker")
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            self.imageView.image = img
        }
    }
}

extension NSManagedObject {

    func copyEntireObjectGraph(context: NSManagedObjectContext) -> NSManagedObject {

        var cache = Dictionary<NSManagedObjectID, NSManagedObject>()
        return cloneObject(context: context, cache: &cache)

    }

    func cloneObject(context: NSManagedObjectContext, cache alreadyCopied: inout Dictionary<NSManagedObjectID, NSManagedObject>) -> NSManagedObject {

        guard let entityName = self.entity.name else {
            fatalError("source.entity.name == nil")
        }

        if let storedCopy = alreadyCopied[self.objectID] {
            return storedCopy
        }

        let cloned = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    alreadyCopied[self.objectID] = cloned

        if let attributes = NSEntityDescription.entity(forEntityName: entityName, in: context)?.attributesByName {

            for key in attributes.keys {
                cloned.setValue(self.value(forKey: key), forKey: key)
            }

        }

        if let relationships = NSEntityDescription.entity(forEntityName: entityName, in: context)?.relationshipsByName {

            for (key, value) in relationships {

                if value.isToMany {

                    if let sourceSet = self.value(forKey: key) as? NSMutableOrderedSet {

                        guard let clonedSet = cloned.value(forKey: key) as? NSMutableOrderedSet else {
                            fatalError("Could not cast relationship \(key) to an NSMutableOrderedSet")
                        }

                        let enumerator = sourceSet.objectEnumerator()

                        var nextObject = enumerator.nextObject() as? NSManagedObject

                        while let relatedObject = nextObject {

                            let clonedRelatedObject = relatedObject.cloneObject(context: context, cache: &alreadyCopied)
                            clonedSet.add(clonedRelatedObject)
                            nextObject = enumerator.nextObject() as? NSManagedObject

                        }

                    } else if let sourceSet = self.value(forKey: key) as? NSMutableSet {

                        guard let clonedSet = cloned.value(forKey: key) as? NSMutableSet else {
                            fatalError("Could not cast relationship \(key) to an NSMutableSet")
                        }

                        let enumerator = sourceSet.objectEnumerator()

                        var nextObject = enumerator.nextObject() as? NSManagedObject

                        while let relatedObject = nextObject {

                            let clonedRelatedObject = relatedObject.cloneObject(context: context, cache: &alreadyCopied)
                            clonedSet.add(clonedRelatedObject)
                            nextObject = enumerator.nextObject() as? NSManagedObject

                        }

                    }

                } else {

                    if let relatedObject = self.value(forKey: key) as? NSManagedObject {

                        let clonedRelatedObject = relatedObject.cloneObject(context: context, cache: &alreadyCopied)
                        cloned.setValue(clonedRelatedObject, forKey: key)

                    }

                }

            }

        }

        return cloned

    }

}


