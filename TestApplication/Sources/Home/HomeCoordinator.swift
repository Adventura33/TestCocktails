//
//  HomeCoordinator.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import Swinject
import UIKit

protocol HomeRoutes {
    func openDetail(id: String)
}

class HomeRouter: Router<UIViewController>, HomeRoutes {
    
    private var resolver: Resolver {
        return AppDependencyManager.shared.resolver
    }
    
    func openDetail(id: String) {
        let coordinator = CocktailsDetailCoordinator(resolver: resolver, detailID: id)
        coordinator.start(from: self, transition: PushTransition())
    }
}

class HomeCoordinator : Coordinator<HomeRouter>{
    init(resolver: Resolver) {
        let router = HomeRouter()
        
        let vm = HomeViewModel(container: .init(routes: router))
        let vc = HomeViewController(container: .init(viewModel: vm))
        router.viewController = vc
        super.init(resolver: resolver, router: router, view: vc)
        vc.coordinator = self
    }
}
