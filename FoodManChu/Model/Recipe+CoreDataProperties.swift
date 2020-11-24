//
//  Recipe+CoreDataProperties.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var prepTime: Int16
    @NSManaged public var name: String?
    @NSManaged public var cookingInstructions: String?
    @NSManaged public var ingredientList: String?
    @NSManaged public var categoryType: String?
    @NSManaged public var summaryDescription: String?
    @NSManaged public var ingredients: Ingredient?
    @NSManaged public var category: Category?

}

extension Recipe : Identifiable {

}
