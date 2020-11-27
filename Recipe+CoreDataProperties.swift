//
//  Recipe+CoreDataProperties.swift
//  FoodManChu
//
//  Created by chris on 11/27/20.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var categoryType: String?
    @NSManaged public var cookingInstructions: String?
    @NSManaged public var ingredientList: [Ingredient]?
    @NSManaged public var name: String?
    @NSManaged public var prepTime: Int16
    @NSManaged public var summaryDescription: String?
    @NSManaged public var category: Category?
    @NSManaged public var ingredients: Ingredient?

}

extension Recipe : Identifiable {

}
