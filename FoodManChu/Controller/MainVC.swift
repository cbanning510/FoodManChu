//
//  ViewController.swift
//  FoodManChu
//
//  Created by chris on 11/23/20.
//
protocol newRecipeModalHandler {
    func dismissModal()
}

import UIKit
import CoreData

class MainVC: UIViewController, ModalHandler, newRecipeModalHandler, UISearchBarDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var controller: NSFetchedResultsController<Recipe>!
    var recipes = [Recipe]()
    var filteredRecipes: [Recipe]!
    var selectedSearchByType: String?
    var categories: [Category]?
    var categoryPickerData: [String] = [String]()
    var categoryPicker  = UIPickerView()
    var isPickerVisible = false
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredRecipes = recipes
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        fetchCategories()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        //generateDummyCategories()
        //generateDummyIngredients()
        //generateDummyRecipes()
        
        attemptFetch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var result = true
        if segmentedControl.selectedSegmentIndex == 4 {
            if (text.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil) {
                result = true
            } else {
                result = false
            }
        }
        return result
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
    }
    
    func search() {
        filteredRecipes = []
        
        if searchBar.text!.isEmpty {
            attemptFetch()
        } else {
                for recipe in recipes {
                    switch selectedSearchByType {
                        case "Ingredient":
                            let ingredients = recipe.ingredients as! Set<Ingredient>
                            for i in ingredients {
                                if i.name!.lowercased().contains(searchBar.text!.lowercased()) {
                                    if !filteredRecipes.contains(recipe) {
                                        filteredRecipes.append(recipe)
                                    }
                                }
                            }
                        case "Name":
                            if recipe.name!.lowercased().contains(searchBar.text!.lowercased()) {
                                if !filteredRecipes.contains(recipe) {
                                    filteredRecipes.append(recipe)
                                }
                            }
                        case "Description":
                            if recipe.summaryDescription!.lowercased().contains(searchBar.text!.lowercased()) {
                                if !filteredRecipes.contains(recipe) {
                                    filteredRecipes.append(recipe)
                                }
                            }
                        case "Time":
                                if Int(recipe.prepTime) <= Int(searchBar.text!)! {
                                    if !filteredRecipes.contains(recipe) {
                                        filteredRecipes.append(recipe)
                                    }
                                }
                        case "Category":
                            if recipe.categoryType!.lowercased().contains(searchBar.text!.lowercased()) {
                                if !filteredRecipes.contains(recipe) {
                                    filteredRecipes.append(recipe)
                                }
                            }
                        
                        default:
                            print("blehw")
                    }
                }
                
            }
            self.tableView.reloadData()
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
    
    func dismissModal() { // protocol method for data passing between VC's
        attemptFetch()
    }
    
    func modalDismissed(recipe: Recipe) { // protocol method for data passing between VC's
        attemptFetch()
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        // home base
    }
    
    override func viewWillAppear(_ animated: Bool) {
        attemptFetch()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        self.searchBar.text = nil
        filteredRecipes = []
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedSearchByType = "All"
            print("All")
        case 1:
            selectedSearchByType = "Ingredient"
            print("Ingredient")
        case 2:
            selectedSearchByType = "Name"
            print("Name")
        case 3:
            selectedSearchByType = "Description"
            print("Description")
        case 4:
            selectedSearchByType = "Time"
            print("Time")
        case 5:
            selectedSearchByType = "Category"
            if !self.isPickerVisible {
                populateCategoryPicker()
                self.isPickerVisible = true
                searchBar.isUserInteractionEnabled = false
                //disableTextFields()
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
        default:
            selectedSearchByType = "All"
        }
        attemptFetch()
       tableView.reloadData()
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        categoryPicker.removeFromSuperview()
        isPickerVisible = false
        search()
        searchBar.isUserInteractionEnabled = true
    }
    
    func attemptFetch() {
        let request = Recipe.fetchRequest() as NSFetchRequest<Recipe>
        do {
            self.recipes = try Constants.context.fetch(request)
            if segmentedControl.selectedSegmentIndex == 0 {
                filteredRecipes = self.recipes
            }
            tableView.reloadData()
        } catch let err {
            print(err)
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
            let recipe = filteredRecipes[indexPath.row]
            cell.configCell(recipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        performSegue(withIdentifier: "DetailSegue", sender: recipe)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            print("no")
            if let destination = segue.destination as? RecipeDetailsVC {
                if let recipe = sender as? Recipe {
                    destination.recipeToEdit = recipe
                }
            }
        }
        if segue.identifier == "AddRecipeSegue" {
            print("yes")
            if let destVC = segue.destination as? UINavigationController,
               let targetController = destVC.topViewController as? AddEditTableVC {
                targetController.newRecipeAddDelegate = self
                targetController.isNewRecipe = true
            }
        }
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    
    func generateDummyCategories() {
        let category1 = Category(context: Constants.context)
        category1.name = "Meat"
        let category2 = Category(context: Constants.context)
        category2.name = "Vegetarian"
        let category3 = Category(context: Constants.context)
        category3.name = "Vegan"
        let category4 = Category(context: Constants.context)
        category4.name = "Paleo"
        let category5 = Category(context: Constants.context)
        category5.name = "Keto"
        
        Constants.ad.saveContext()
    }
    
    func generateDummyRecipes() {
        // -- recipe 1 --
        let recipe1 = Recipe(context: Constants.context)
        recipe1.categoryType = "Meat"
        recipe1.name = "Chicken Parmesan"
        recipe1.prepTime = 65
        recipe1.summaryDescription = "Traditional Italian-American favorite"
        
        let ingredient55 = Ingredient(context: Constants.context)
        ingredient55.name = "Canned Tomatoes"
        let ingredient56 = Ingredient(context: Constants.context)
        ingredient56.name = "Panko Bread Crumbs"
        
        recipe1.addToIngredients(ingredient55)
        recipe1.addToIngredients(ingredient56)
        
        let instruction7 = Instruction(context: Constants.context)
        instruction7.summary = "Pound chicken breasts to 1/4 inch thickness"
        let instruction8 = Instruction(context: Constants.context)
        instruction8.summary = "Heat oil in large frying pan to 350 degrees"
        
        recipe1.addToInstructions(instruction7)
        recipe1.addToInstructions(instruction8)
        
        // -- recipe 2 --
        
        let recipe2 = Recipe(context: Constants.context)
        recipe2.categoryType = "Keto"
        recipe2.name = "Cauliflour Alfredo"
        recipe2.prepTime = 44
        recipe2.summaryDescription = "Cauliflour cooked in heavy cream and parmesan cheese"
        
        let ingredient53 = Ingredient(context: Constants.context)
        ingredient53.name = "cauliflour"
        let ingredient54 = Ingredient(context: Constants.context)
        ingredient54.name = "cream"
        
        recipe2.addToIngredients(ingredient53)
        recipe2.addToIngredients(ingredient54)
        
        let instruction5 = Instruction(context: Constants.context)
        instruction5.summary = "Chop cauliflour unto bite-sized pieces"
        let instruction6 = Instruction(context: Constants.context)
        instruction6.summary = "Melt 2 Tbsp butter in medium saucepan"
        
        recipe2.addToInstructions(instruction5)
        recipe2.addToInstructions(instruction6)
        
        // -- recipe 3 --
        
        let recipe3 = Recipe(context: Constants.context)
        recipe3.categoryType = "Paleo"
        recipe3.name = "Mixed Nuts"
        recipe3.prepTime = 2
        recipe3.summaryDescription = "A bowl of mixed nuts straight from the can"
        
        let ingredient51 = Ingredient(context: Constants.context)
        ingredient51.name = "peanuts"
        let ingredient52 = Ingredient(context: Constants.context)
        ingredient52.name = "cashews"
        
        recipe3.addToIngredients(ingredient51)
        recipe3.addToIngredients(ingredient52)
        
        let instruction3 = Instruction(context: Constants.context)
        instruction3.summary = "Open can of mixed nuts"
        let instruction4 = Instruction(context: Constants.context)
        instruction4.summary = "Pour nuts into a bowl"
        
        recipe3.addToInstructions(instruction3)
        recipe3.addToInstructions(instruction4)
        
        // -- recipe 4 --
        
        let recipe4 = Recipe(context: Constants.context)
        recipe4.categoryType = "Vegetarian"
        recipe4.name = "Blueberry Muffins"
        recipe4.prepTime = 27
        recipe4.summaryDescription = "Sweet corn muffins with tangy blueberries"
        
        let ingredient1 = Ingredient(context: Constants.context)
        ingredient1.name = "blueberries"
        let ingredient2 = Ingredient(context: Constants.context)
        ingredient2.name = "flour"
        
        recipe4.addToIngredients(ingredient1)
        recipe4.addToIngredients(ingredient2)
        
        let instruction1 = Instruction(context: Constants.context)
        instruction1.summary = "Preheat oven to 350"
        let instruction2 = Instruction(context: Constants.context)
        instruction2.summary = "Wash and dry blueberries"
        
        recipe4.addToInstructions(instruction1)
        recipe4.addToInstructions(instruction2)
        
        // -- recipe 5 --
        
        let recipe5 = Recipe(context: Constants.context)
        recipe5.categoryType = "Vegan"
        recipe5.name = "Tossed salad"
        recipe5.prepTime = 14
        recipe5.summaryDescription = "Vegan delight consisting of mixed greens"
        
        let ingredient57 = Ingredient(context: Constants.context)
        ingredient57.name = "iceberg lettuce"
        let ingredient58 = Ingredient(context: Constants.context)
        ingredient58.name = "red cabbage"
        
        recipe5.addToIngredients(ingredient57)
        recipe5.addToIngredients(ingredient58)
        
        let instruction9 = Instruction(context: Constants.context)
        instruction9.summary = "Wash, clean, and dry lettuce and cabbage"
        let instruction10 = Instruction(context: Constants.context)
        instruction10.summary = "Grate red cabbage with cheese grater"
        
        recipe5.addToInstructions(instruction1)
        recipe5.addToInstructions(instruction2)
        
        Constants.ad.saveContext()
    }
    
    func generateDummyIngredients() {
        let ingredient3 = Ingredient(context: Constants.context)
        ingredient3.name = "unsalted butter"
        let ingredient4 = Ingredient(context: Constants.context)
        ingredient4.name = "egg"
        let ingredient5 = Ingredient(context: Constants.context)
        ingredient5.name = "egg white"
        let ingredient6 = Ingredient(context: Constants.context)
        ingredient6.name = "egg yolk"
        let ingredient7 = Ingredient(context: Constants.context)
        ingredient7.name = "ground beef"
        let ingredient8 = Ingredient(context: Constants.context)
        ingredient8.name = "chicken breast"
        let ingredient9 = Ingredient(context: Constants.context)
        ingredient9.name = "ground pork"
        let ingredient10 = Ingredient(context: Constants.context)
        ingredient10.name = "pork tenderloin"
        let ingredient11 = Ingredient(context: Constants.context)
        ingredient11.name = "chicken tender"
        let ingredient12 = Ingredient(context: Constants.context)
        ingredient12.name = "cheddar cheese"
        let ingredient13 = Ingredient(context: Constants.context)
        ingredient13.name = "swiss cheese"
        let ingredient14 = Ingredient(context: Constants.context)
        ingredient14.name = "romano cheese"
        let ingredient15 = Ingredient(context: Constants.context)
        ingredient15.name = "parmesan cheese"
        let ingredient16 = Ingredient(context: Constants.context)
        ingredient16.name = "cream cheese"
        let ingredient17 = Ingredient(context: Constants.context)
        ingredient17.name = "mozzarella cheese"
        let ingredient18 = Ingredient(context: Constants.context)
        ingredient18.name = "milk"
        let ingredient19 = Ingredient(context: Constants.context)
        ingredient19.name = "sugar"
        let ingredient20 = Ingredient(context: Constants.context)
        ingredient20.name = "salt"
        let ingredient21 = Ingredient(context: Constants.context)
        ingredient21.name = "pepper"
        let ingredient22 = Ingredient(context: Constants.context)
        ingredient22.name = "onion powder"
        let ingredient23 = Ingredient(context: Constants.context)
        ingredient23.name = "garlic powder"
        let ingredient24 = Ingredient(context: Constants.context)
        ingredient24.name = "basil"
        let ingredient25 = Ingredient(context: Constants.context)
        ingredient25.name = "parsley"
        let ingredient26 = Ingredient(context: Constants.context)
        ingredient26.name = "thyme"
        let ingredient27 = Ingredient(context: Constants.context)
        ingredient27.name = "oregano"
        let ingredient28 = Ingredient(context: Constants.context)
        ingredient28.name = "garlic"
        let ingredient29 = Ingredient(context: Constants.context)
        ingredient29.name = "onion"
        let ingredient30 = Ingredient(context: Constants.context)
        ingredient30.name = "celery"
        let ingredient31 = Ingredient(context: Constants.context)
        ingredient31.name = "carrot"
        let ingredient32 = Ingredient(context: Constants.context)
        ingredient32.name = "paprika"
        let ingredient33 = Ingredient(context: Constants.context)
        ingredient33.name = "lettuce"
        let ingredient34 = Ingredient(context: Constants.context)
        ingredient34.name = "broccoli"
        let ingredient35 = Ingredient(context: Constants.context)
        ingredient35.name = "turnips"
        let ingredient36 = Ingredient(context: Constants.context)
        ingredient36.name = "asparagus"
        let ingredient37 = Ingredient(context: Constants.context)
        ingredient37.name = "black beans"
        let ingredient38 = Ingredient(context: Constants.context)
        ingredient38.name = "corn"
        let ingredient39 = Ingredient(context: Constants.context)
        ingredient39.name = "tomato"
        let ingredient40 = Ingredient(context: Constants.context)
        ingredient40.name = "olive oil"
        let ingredient41 = Ingredient(context: Constants.context)
        ingredient41.name = "vegetable oil"
        let ingredient42 = Ingredient(context: Constants.context)
        ingredient42.name = "white bread"
        let ingredient43 = Ingredient(context: Constants.context)
        ingredient43.name = "wheat bread"
        let ingredient44 = Ingredient(context: Constants.context)
        ingredient44.name = "bread crumbs"
        let ingredient45 = Ingredient(context: Constants.context)
        ingredient45.name = "green pepper"
        let ingredient46 = Ingredient(context: Constants.context)
        ingredient46.name = "american cheese"
        let ingredient47 = Ingredient(context: Constants.context)
        ingredient47.name = "pasta"
        let ingredient48 = Ingredient(context: Constants.context)
        ingredient48.name = "chicken broth"
        let ingredient49 = Ingredient(context: Constants.context)
        ingredient49.name = "ribeye steak"
        let ingredient50 = Ingredient(context: Constants.context)
        ingredient50.name = "water"
        
        Constants.ad.saveContext()
    }
    
}

extension MainVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchBar.text = categoryPickerData[row]
        tableView.reloadData()
    }

}

