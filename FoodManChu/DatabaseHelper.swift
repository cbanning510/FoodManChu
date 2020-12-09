//
//  DatabaseHelper.swift
//  FoodManChu
//
//  Created by chris on 12/9/20.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper {
    
    static let instance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveImageInCoreData(at imgData: Data) {
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context) as! Recipe
        recipe.image = imgData
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getAllImages() -> [Recipe]{
        var arrRecipe = [Recipe]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        do {
            arrRecipe = try context.fetch(fetchRequest) as! [Recipe]
        } catch let error {
            print(error.localizedDescription)
        }
        return arrRecipe
    }
    
}

