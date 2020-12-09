//
//  Recipe+CoreDataProperties.swift
//  FoodManChu
//
//  Created by chris on 12/9/20.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var categoryType: String?
    @NSManaged public var cookTime: Int64
    @NSManaged public var id: Int64
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var prepTime: Int64
    @NSManaged public var summaryDescription: String?
    @NSManaged public var category: Category?
    @NSManaged public var ingredients: NSOrderedSet?
    @NSManaged public var instructions: NSOrderedSet?

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(insertObject:inIngredientsAtIndex:)
    @NSManaged public func insertIntoIngredients(_ value: Ingredient, at idx: Int)

    @objc(removeObjectFromIngredientsAtIndex:)
    @NSManaged public func removeFromIngredients(at idx: Int)

    @objc(insertIngredients:atIndexes:)
    @NSManaged public func insertIntoIngredients(_ values: [Ingredient], at indexes: NSIndexSet)

    @objc(removeIngredientsAtIndexes:)
    @NSManaged public func removeFromIngredients(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientsAtIndex:withObject:)
    @NSManaged public func replaceIngredients(at idx: Int, with value: Ingredient)

    @objc(replaceIngredientsAtIndexes:withIngredients:)
    @NSManaged public func replaceIngredients(at indexes: NSIndexSet, with values: [Ingredient])

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSOrderedSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSOrderedSet)

}

// MARK: Generated accessors for instructions
extension Recipe {

    @objc(insertObject:inInstructionsAtIndex:)
    @NSManaged public func insertIntoInstructions(_ value: Instruction, at idx: Int)

    @objc(removeObjectFromInstructionsAtIndex:)
    @NSManaged public func removeFromInstructions(at idx: Int)

    @objc(insertInstructions:atIndexes:)
    @NSManaged public func insertIntoInstructions(_ values: [Instruction], at indexes: NSIndexSet)

    @objc(removeInstructionsAtIndexes:)
    @NSManaged public func removeFromInstructions(at indexes: NSIndexSet)

    @objc(replaceObjectInInstructionsAtIndex:withObject:)
    @NSManaged public func replaceInstructions(at idx: Int, with value: Instruction)

    @objc(replaceInstructionsAtIndexes:withInstructions:)
    @NSManaged public func replaceInstructions(at indexes: NSIndexSet, with values: [Instruction])

    @objc(addInstructionsObject:)
    @NSManaged public func addToInstructions(_ value: Instruction)

    @objc(removeInstructionsObject:)
    @NSManaged public func removeFromInstructions(_ value: Instruction)

    @objc(addInstructions:)
    @NSManaged public func addToInstructions(_ values: NSOrderedSet)

    @objc(removeInstructions:)
    @NSManaged public func removeFromInstructions(_ values: NSOrderedSet)

}

extension Recipe : Identifiable {

}
