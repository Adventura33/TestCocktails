//
//  HomeViewModel.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import RxSwift
import struct RxCocoa.Signal
import struct RxCocoa.Driver

class HomeViewModel {
    
    //MARK: - Private Properties
    private let routes: HomeRouter
    
    // MARK: - Init
    required init(container: Container) {
        self.routes = container.routes
    }
}

// MARK: - IViewModeling
extension HomeViewModel: IViewModeling {
    // MARK: - Input
    
    struct Input {
        let bag: DisposeBag
    }
    
    // MARK: - Output
    
    struct Output {
        
    }
    
    func transform(input: Input, outputHandler: (Output) -> Void) {
        
        outputHandler(.init())
    }
}

extension HomeViewModel: DIConfigurable {
    struct Container {
        let routes: HomeRouter
    }
}
