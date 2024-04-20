//
//  AssetsColor.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 19.04.2024.
//

import Foundation
import UIKit

enum AssetsColor: String {
    case yellow
    case lightDark
    case white
    case secondaryText
    case background
    case titleColor
    case overlay
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
         return UIColor(named: name.rawValue)
    }
}
