//
//  AppDependencyManager.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import Swinject

class AppDependencyManager {

    static let shared = AppDependencyManager()

    private let container: Container

    var resolver: Resolver {
        return container
    }

    private init() {
        let container = Container()
        self.container = container
    }
}
