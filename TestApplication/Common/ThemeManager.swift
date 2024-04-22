//
//  ThemeManager.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 22.04.2024.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    
    var currentTheme: UIUserInterfaceStyle = .light {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("themeDidChange"), object: nil)
        }
    }
    
    func changeTheme() {
        currentTheme = currentTheme == .light ? .dark : .light
    }
}
