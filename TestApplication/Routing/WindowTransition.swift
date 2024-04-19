//
//  WindowTransition.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import UIKit

class WindowTransition: NSObject {
    weak var viewController: UIViewController?
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    init(delegate: AppDelegate) {
        if let window = delegate.window {
            self.window = window
        } else {
            self.window = UIWindow()
            delegate.window = self.window
        }
    }
}

// MARK: - Transition

extension WindowTransition: ITransition {

    @objc
    func open(_ viewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
        window.makeKeyAndVisible()
    }
    
    func close(_ viewController: UIViewController) { }
}
