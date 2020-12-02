//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//

import UIKit
import CoreData

class IngredientsVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Ingredient>!
    var ingredients: [Ingredient]?
    var recipeToEdit: Recipe?
    weak var recipeDetailsVC: NewRecipeDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attemptIngredientFetch()
        
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func attemptIngredientFetch() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()
            ingredients = controller.sections![0].objects as? [Ingredient]
        } catch let err {
            print(err)
        }
    }
}

extension IngredientsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
            return UITableViewCell()
        }
        configureCell(cell, indexPath: indexPath)
        return cell
    }    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    // replace with trailingswipeAction etc.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if let sections = controller.sections {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                ingredients?.remove(at: indexPath.row)
                Constants.context.delete(sections[0].objects![indexPath.row] as! Ingredient)
                Constants.ad.saveContext()
            }
            attemptIngredientFetch()
            tableView.endUpdates()
            tableView.reloadData()            
        }
    }
    
    func configureCell(_ cell: IngredientCell, indexPath: IndexPath) {
        let ingredient = controller.object(at: indexPath)
        cell.configCell(ingredient)
    }
}
