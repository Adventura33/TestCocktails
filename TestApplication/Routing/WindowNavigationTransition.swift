//
//  File.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import UIKit

class WindowNavigationTransition: WindowTransition {

    override func open(_ viewController: UIViewController) {
        let nc = UINavigationController(rootViewController: viewController)
        super.open(nc)
    }
}
