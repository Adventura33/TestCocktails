//
//  UIFont+Extension.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import UIKit

extension UIFont {
    
    static public func regular(fontSize: CGFloat) -> UIFont {
        return self.aliceRegular(size: fontSize)
    }
    
    static public func aliceRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Alice-Regular", size: size)!
    }
}
