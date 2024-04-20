//
//  AssetsImage.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import UIKit

enum AssetsImage {
    enum Common: String {
        case search = "search"
        case close = "close"
        case back = "back"
        case error = "error"
    }
    enum CocktailsType: String {
        case beer = "beer"
        case cocktail = "cocktail"
        case cocoa = "cocoa"
        case coffee = "coffee"
        case drinkOnTheParty = "drinkOnTheParty"
        case liquor = "liquor"
        case other = "other"
        case regularDrink = "regularDrink"
        case shot = "shot"
        case smoothieShake = "smoothieShake"
        case softDrink = "softDrink"
    }
}

extension RawRepresentable where RawValue == String {
    var image: UIImage {
        guard let image = UIImage(named: rawValue) else {
            //TODO: LOG THE ERROR THAT IMAGE DOES NOT EXIST
            return .init()
        }
        return image
    }
}
