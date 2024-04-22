//
//  CocktailsDetailCoordinator.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import Swinject
import UIKit

protocol CocktailsDetailRoutes {
}

class CocktailsDetailRouter: Router<UIViewController>, CocktailsDetailRoutes {
    private var resolver: Resolver {
        return AppDependencyManager.shared.resolver
    }
}

class CocktailsDetailCoordinator: Coordinator<CocktailsDetailRouter> {
    init(resolver: Resolver, detailID: String) {
        let router = CocktailsDetailRouter()
        let vm = CocktailsDetailViewModel(container: .init(routes: router, detailID: detailID))
        let vc = CocktailsDetailViewController(container: .init(viewModel: vm))
        router.viewController = vc
        super.init(resolver: resolver, router: router, view: vc)
    }
}
