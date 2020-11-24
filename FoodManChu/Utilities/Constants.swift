//
//  Constants.swift
//  FoodManChu
//
//  Created by chris on 11/24/20.
//

import Foundation
import UIKit

enum Constants {
    static var materialKey: Bool = false
    static let ad = UIApplication.shared.delegate as! AppDelegate
    static let context = ad.persistentContainer.viewContext
    static let cellReuseId = "RecipeCell"
}
