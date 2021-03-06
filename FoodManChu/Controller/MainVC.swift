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

class MainVC: UIViewController,  UISearchBarDelegate {
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
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        self.searchBar.resignFirstResponder()
        fetchCategories()
        attemptFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear in nMainVC")
        attemptFetch()
        tableView.reloadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        print("view Will Appear MainVC!!!")
//        //attemptFetch()
//
//    }
    
    
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
                case "All":
                    filteredRecipes = recipes
                case "Ingredient":
                    if let ingredients = recipe.ingredients {
                        for i in ingredients {
                            if (i as AnyObject).name!.lowercased().contains(searchBar.text!.lowercased()) {
                                if !filteredRecipes.contains(recipe) {
                                    filteredRecipes.append(recipe)
                                }
                            }
                        }
                    }
                    //let ingredients = recipe.ingredients as! Set<Ingredient>
                    
                case "Name":
                    if recipe.name!.lowercased().contains(searchBar.text!.lowercased()) {
                        filteredRecipes.append(recipe)
                    }
                case "Description":
                    if recipe.summaryDescription!.lowercased().contains(searchBar.text!.lowercased()) {
                        filteredRecipes.append(recipe)
                    }
                case "Time":
                    if Int(recipe.prepTime) <= Int(searchBar.text!)! {
                        filteredRecipes.append(recipe)
                    }
                case "Category":
                    if let categoryType = recipe.categoryType {
                        if categoryType.lowercased().contains(searchBar.text!.lowercased()) {
                            filteredRecipes.append(recipe)
                        }
                    }
                    
                default:
                    filteredRecipes = recipes
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
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        // home base
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        //self.searchBar.becomeFirstResponder()
        self.searchBar.text = nil
        filteredRecipes = []
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedSearchByType = "All"
        case 1:
            selectedSearchByType = "Ingredient"
        case 2:
            selectedSearchByType = "Name"
        case 3:
            selectedSearchByType = "Description"
        case 4:
            selectedSearchByType = "Time"
        case 5:
            selectedSearchByType = "Category"
            showPickerAndToolbar()
        default:
            selectedSearchByType = "All"
        }
        attemptFetch()
       tableView.reloadData()
    }
    
    func showPickerAndToolbar() {
        if !self.isPickerVisible {
            populateCategoryPicker()
            self.isPickerVisible = true
            searchBar.isUserInteractionEnabled = false
            segmentedControl.isUserInteractionEnabled = false
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
        toolBar.removeFromSuperview()
        categoryPicker.removeFromSuperview()
        isPickerVisible = false
        search()
        searchBar.isUserInteractionEnabled = true
        segmentedControl.isUserInteractionEnabled = true
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
        let recipe = filteredRecipes[indexPath.row]
        performSegue(withIdentifier: "DetailSegue", sender: recipe)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        if segue.identifier == "DetailSegue" {
            if let destination = segue.destination as? RecipeDetailsVC {
                if let recipe = sender as? Recipe {
                    destination.recipeToEdit = recipe
                }
            }
        }
        if segue.identifier == "AddRecipeSegue" {
            view.endEditing(true)
            if let destVC = segue.destination as? UINavigationController,
               let targetController = destVC.topViewController as? AddEditTableVC {
                targetController.newRecipeAddDelegate = self
                targetController.isNewRecipe = true
            }
        }
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchBar.text = categoryPickerData[row]
        tableView.reloadData()
    }
}

extension MainVC: newRecipeModalHandler {
    
    func dismissModal() { // protocol method for data passing between VC's
        attemptFetch()
        tableView.reloadData()
    }
}

extension MainVC: ModalHandler {
    func modalDismissed(recipe: Recipe) { // protocol method for data passing between VC's
        attemptFetch()
        tableView.reloadData()
    }
}

