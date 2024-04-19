//
//  PushTransition.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 19.04.2024.
//

import Foundation
import UIKit

public class PushTransition: NSObject {

    var animator: Animator?
    var shouldCrossDissolve: Bool = false
    var isAnimated: Bool = true
    var completionHandler: (() -> Void)?

    weak public var viewController: UIViewController?

    public init(animator: Animator? = nil, isAnimated: Bool = true, shouldCrossDissolve: Bool = false) {
        self.animator = animator
        self.isAnimated = isAnimated
        self.shouldCrossDissolve = shouldCrossDissolve
    }

    deinit {
        print("💀: Transition \(self) deinited")
    }
}

// MARK: - Transition

extension PushTransition: ITransition {

    public func open(_ viewController: UIViewController) {
        if (shouldCrossDissolve) {
            self.viewController?.navigationController?.view.layer.add(getCrossDissolveTransition(), forKey: nil)
            self.viewController?.navigationController?.pushViewController(viewController, animated: false)
        } else {
            self.viewController?.navigationController?.pushViewController(viewController, animated: isAnimated)
        }
    }

    public func close(_ viewController: UIViewController) {
        if (shouldCrossDissolve) {
            self.viewController?.navigationController?.view.layer.add(getCrossDissolveTransition(), forKey: nil)
            self.viewController?.navigationController?.popViewController(animated: false)
        } else {
            self.viewController?.navigationController?.popViewController(animated: isAnimated)
        }
    }
    
    private func getCrossDissolveTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.23
        transition.type = CATransitionType.fade
        return transition
    }
}

extension PushTransition: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        completionHandler?()
    }

    public func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animator else {
            return nil
        }
        if operation == .push {
            animator.isPresenting = true
            return animator
        } else {
            animator.isPresenting = false
            return animator
        }
    }
}
