//
//  Recipe+CoreDataProperties.swift
//  FoodManChu
//
//  Created by chris on 12/1/20.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var categoryType: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var prepTime: Int64
    @NSManaged public var summaryDescription: String?
    @NSManaged public var cookTime: Int64
    @NSManaged public var category: Category?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var instructions: NSSet?

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for instructions
extension Recipe {

    @objc(addInstructionsObject:)
    @NSManaged public func addToInstructions(_ value: Instruction)

    @objc(removeInstructionsObject:)
    @NSManaged public func removeFromInstructions(_ value: Instruction)

    @objc(addInstructions:)
    @NSManaged public func addToInstructions(_ values: NSSet)

    @objc(removeInstructions:)
    @NSManaged public func removeFromInstructions(_ values: NSSet)

}

extension Recipe : Identifiable {

}
