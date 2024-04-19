//
//  HomeViewController.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Swinject
import SnapKit

class HomeViewController: BaseController<HomeCoordinator>, IAutoSetup {
    
    //MARK: - Public properties
    let viewModel: HomeViewModel
    
    //MARK: - UIElements
    
    required init(container: Container) {
        self.viewModel = container.viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IViewModelOwner
extension HomeViewController: IViewModelOwner {
    
    func createInput() {
        let input = HomeViewModel.Input(bag: bag)
        viewModel.transform(input: input, outputHandler: subscribeToOutput(_:))
    }
    
    func subscribeToOutput(_ output: HomeViewModel.Output) {
        
    }
    
}

// MARK: - DIConfigurable
extension HomeViewController: DIConfigurable {
    struct Container {
        let viewModel: HomeViewModel
    }
}
