//
//  DetailCategory.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 21.04.2024.
//

import Foundation
import UIKit

enum DetailCategory: String {
    case shake = "Shake"
    case beer = "Beer"
    case shot = "Shot"
    case punchPartyDrink = "Punch / Party Drink"
    case ordinaryDrink = "Ordinary Drink"
    case coffeeTea = "Coffee / Tea"
    case homemadeLiqueur = "Homemade Liqueur"
    case otherUnknown = "Other / Unknown"

    var image: UIImage {
        switch self {
        case .shake:
            return AssetsImage.CocktailsType.smoothieShake.image
        case .beer:
            return AssetsImage.CocktailsType.beer.image
        case .shot:
            return AssetsImage.CocktailsType.shot.image
        case .punchPartyDrink:
            return AssetsImage.CocktailsType.drinkOnTheParty.image
        case .ordinaryDrink:
            return AssetsImage.CocktailsType.softDrink.image
        case .coffeeTea:
            return AssetsImage.CocktailsType.coffee.image
        case .homemadeLiqueur:
            return AssetsImage.CocktailsType.liquor.image
        case .otherUnknown:
            return AssetsImage.CocktailsType.other.image
        }
    }
}
