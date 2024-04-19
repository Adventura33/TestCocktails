//
//  IAutoSetup.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation

protocol IAutoSetup {
    var shouldSetupAutomatically: Bool { get }

    func performAutoSetup()
}

extension IAutoSetup where Self: IViewModelOwner {

    var shouldSetupAutomatically: Bool {
        return true
    }

    func performAutoSetup() {
        createInput()
    }
}
