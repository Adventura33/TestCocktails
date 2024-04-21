//
//  DrinksDetailList.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 21.04.2024.
//

import Foundation

struct DrinksDetailList: Codable {
    let drinks: [DrinksDetail]
}

struct DrinksDetail : Codable {
    let idDrink : String?
    let strDrink : String?
    let strDrinkAlternate : String?
    let strTags : String?
    let strVideo : String?
    let strCategory : String?
    let strIBA : String?
    let strAlcoholic : String?
    let strGlass : String?
    let strInstructions : String?
    let strDrinkThumb : String?
    let strImageSource : String?
    let strImageAttribution : String?
    let strCreativeCommonsConfirmed : String?
    let dateModified : String?
}
