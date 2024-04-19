//
//  Router.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import UIKit

protocol IRouter: class {
    associatedtype Controller: UIViewController
    var viewController: Controller? { get }
    var openTransition: ITransition? { get set }

    func open(_ viewController: UIViewController, transition: ITransition)
}

class Router<VC>: IRouter, Closable where VC: UIViewController {
    typealias Controller = VC

    weak var viewController: Controller?
    var openTransition: ITransition?

    func open(_ viewController: UIViewController, transition: ITransition) {
        transition.viewController = self.viewController
        transition.open(viewController)
    }

    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)
    }
    
    deinit {
        print("💀: Router \(self) deinited")
    }
}
