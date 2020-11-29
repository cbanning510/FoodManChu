//
//  Ingredient+CoreDataProperties.swift
//  FoodManChu
//
//  Created by chris on 11/29/20.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var amount: String?
    @NSManaged public var name: String?
    @NSManaged public var recipe: NSSet?

}

// MARK: Generated accessors for recipe
extension Ingredient {

    @objc(addRecipeObject:)
    @NSManaged public func addToRecipe(_ value: Recipe)

    @objc(removeRecipeObject:)
    @NSManaged public func removeFromRecipe(_ value: Recipe)

    @objc(addRecipe:)
    @NSManaged public func addToRecipe(_ values: NSSet)

    @objc(removeRecipe:)
    @NSManaged public func removeFromRecipe(_ values: NSSet)

}

extension Ingredient : Identifiable {

}
