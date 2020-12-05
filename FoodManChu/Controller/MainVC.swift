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

class MainVC: UIViewController, ModalHandler, newRecipeModalHandler {
    func dismissModal() {
        print("dismiss modal for new recipe from MainVC")
        attemptFetch()
    }
    
    func modalDismissed(recipe: Recipe) {
        print("modaldsimissed from MainVC")
        attemptFetch()
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Recipe>!
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateDummyCategories()
        //generateDummyIngredients()
        //generateDummyRecipes()
        
        attemptFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will apear in MainVC!!!")
        attemptFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidApear in MainVC")
    }
    
    func attemptFetch() {
        let request = Recipe.fetchRequest() as NSFetchRequest<Recipe>
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        do {
            self.recipes = try Constants.context.fetch(request)
            tableView.reloadData()
        } catch let err {
            print(err)
        }
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        let recipe = recipes[indexPath.row]
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
                //targetController.recipeToEdit = recipeToEdit
                //let recipe = Recipe(context: Constants.context)
                //print("is recipe nil? \(recipe)")
                targetController.isNewRecipe = true
                //targetController. recipeToEdit = recipe
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
        let recipe1 = Recipe(context: Constants.context)
        recipe1.id = 0
        recipe1.categoryType = "Vegetarian"
        recipe1.name = "Chicken Parmesan"
        recipe1.prepTime = 60
        recipe1.summaryDescription = "My favorite Italian entree"
        
        let recipe2 = Recipe(context: Constants.context)
        recipe2.id = 1
        recipe2.categoryType = "Vegan"
        recipe2.name = "Vegan Alfredo"
        recipe2.prepTime = 45
        recipe2.summaryDescription = "Tossed in a delicious cashew hemp wtf cream"
        
        let recipe3 = Recipe(context: Constants.context)
        recipe3.id = 2
        recipe3.categoryType = "Paleo"
        recipe3.name = "Mixed Nuts"
        recipe3.prepTime = 2
        recipe3.summaryDescription = "A bowl of mixed nuts straight from the can"
        
        let recipe4 = Recipe(context: Constants.context)
        recipe4.id = 3
        recipe4.categoryType = "Ke to"
        recipe4.name = "Blueberry Muffins"
        recipe4.prepTime = 44
        recipe4.summaryDescription = "Superb decadence that only a crate of blueberries could provide"
        
        let ingredient1 = Ingredient(context: Constants.context)
        ingredient1.name = "milk"
        let ingredient2 = Ingredient(context: Constants.context)
        ingredient2.name = "cream"
        
        recipe4.addToIngredients(ingredient1)
        recipe4.addToIngredients(ingredient2)
        
        let instruction1 = Instruction(context: Constants.context)
        instruction1.summary = "Preheat oven to 350"
        let instruction2 = Instruction(context: Constants.context)
        instruction2.summary = "Wash and dry blueberries"
        
        recipe4.addToInstructions(instruction1)
        recipe4.addToInstructions(instruction2)
        
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
        ingredient18.name = "flour"
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
        ingredient35.name = "cauliflour"
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

