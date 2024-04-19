//
//  ITransition.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import UIKit

protocol ITransition: class {
    var viewController: UIViewController? { get set }
    
    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}
