//
//  Coordinator.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 22.04.2024.
//

import Foundation
import UIKit
import Swinject

protocol ICoordinator: class {
    associatedtype Router: IRouter

    var router: Router { get }

    func start<R: IRouter>(from router: R, transition: ITransition)
}


class Coordinator<R: IRouter>: ICoordinator {

    let resolver: Resolver
    let router: R
    var view: UIViewController?
    weak var weakView: UIViewController?

    var coordinatorView : UIViewController? {
        get {
            return view ?? weakView
        }
    }

    init(resolver: Resolver, router: R, view: UIViewController? = nil) {
        self.resolver = resolver
        self.router = router
        self.view = view
        self.weakView = view
    }
    
    deinit {
        print("💀: Coordinator \(self) deinited")
    }


    func start<R>(from router: R, transition: ITransition) where R: IRouter {
        guard let viewController = self.router.viewController else {
            assertionFailure("Cannot start because of router has no host view controller")
            return
        }
        
        router.open(viewController, transition: transition)
        self.view = nil
        self.router.openTransition = transition
    }
}
