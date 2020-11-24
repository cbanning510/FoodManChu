//
//  ViewController.swift
//  FoodManChu
//
//  Created by chris on 11/23/20.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Recipe>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateDummyData()
        attemptFetch()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // sections is a row of data:
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        //print("form cell")
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureCell(_ cell: RecipeCell, indexPath: IndexPath) {
        let recipe = controller.object(at: indexPath)
        cell.configCell(recipe)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("didSelectRowAt")
        if let objs = controller.fetchedObjects, objs.count > 0 { // objs return from fetch
            //print("objs is: \(objs)")
            let recipe = objs[indexPath.row]
            //print("recipe is: \(recipe)")
            performSegue(withIdentifier: "DetailSegue", sender: recipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let destination = segue.destination as? RecipeDetailsVC {
                if let recipe = sender as? Recipe {
                    print(recipe)
                    destination.recipeToEdit = recipe
                }
            }
        }
    }
    
    
    
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func generateDummyData() {
        let recipe1 = Recipe(context: Constants.context)
        recipe1.categoryType = "Vegetarian"
        recipe1.name = "Chicken Parmesan"
        recipe1.prepTime = 60
        recipe1.summaryDescription = "My favorite Italian entree"
        
        let recipe2 = Recipe(context: Constants.context)
        recipe2.categoryType = "Vegan"
        recipe2.name = "Vegan Alfredo"
        recipe2.prepTime = 45
        recipe2.summaryDescription = "Tossed in a delicious cashew hemp wtf cream"
        
        let recipe3 = Recipe(context: Constants.context)
        recipe3.categoryType = "Paleo"
        recipe3.name = "Mixed Nuts"
        recipe3.prepTime = 2
        recipe3.summaryDescription = "A bowl of mixed nuts straight from the can"
        
        let recipe4 = Recipe(context: Constants.context)
        recipe4.categoryType = "Ke to"
        recipe4.name = "Blueberry Muffins"
        recipe4.prepTime = 44
        recipe4.summaryDescription = "Superb decadence that only a crate of blueberries could provide"
        
        Constants.ad.saveContext()
    }
    // fetch Core Data:
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        //let priceSort = NSSortDescriptor(key: "price", ascending: true)
        //let titleSort = NSSortDescriptor(key: "name", ascending: true)
        
//        switch segmentedControl.selectedSegmentIndex {
//        case 0:
//            print("1")
//            fetchRequest.sortDescriptors = [dateSort]
//        case 1:
//            print("2")
//            fetchRequest.sortDescriptors = [priceSort]
//        case 2:
//            print("3")
//            fetchRequest.sortDescriptors = [titleSort]
//        default:
//            print("4")
//            break
//        }
        
        // create instance of results controller
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        // get access to properties and methods of controller:
        controller.delegate = self
        // assign instance to variable:
        self.controller = controller
        
        do {
            // perform actual core data fetch:
            try controller.performFetch()
        } catch let err {
            print(err)
        }
    }
}

