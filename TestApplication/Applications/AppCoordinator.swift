//
//  AppCoordinator.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 22.04.2024.
//

import Foundation
import UIKit
import Swinject

class AppRouter: Router<UIViewController> {}

class AppCoordinator: Coordinator<AppRouter> {

    private weak var delegate: AppDelegate?

    init(resolver: Resolver, delegate: AppDelegate) {
        self.delegate = delegate

        super.init(resolver: resolver, router: AppRouter())
    }

    func start() {
        guard let delegate = delegate else {
            return
        }

        let transition = WindowNavigationTransition(delegate: delegate)
        HomeCoordinator(resolver: resolver).start(from: router, transition: transition)
    }
    
    @available(*, unavailable)
    override func start<R>(from router: R, transition: ITransition) where R: IRouter {
        super.start(from: router, transition: transition)
    }
}
