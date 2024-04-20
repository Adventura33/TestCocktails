//
//  CocktailsDetailViewModel.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Swinject

class CocktailsDetailViewModel {
    
    //MARK: - Private Properties
    private let routes: CocktailsDetailRouter
    private let bag = DisposeBag()
    
    private let cocktailsDetail = BehaviorRelay<DrinksDetail?>(value: nil)
    private let isLoading = PublishRelay<Bool>()
    
    private let detailId: String
    
    // MARK: - Init
    required init(container: Container) {
        self.routes = container.routes
        self.detailId = container.detailID
        fetch()
    }
    
    func fetch() {
        self.getCocktailList(id: detailId)
    }
}

// MARK: - IViewModeling
extension CocktailsDetailViewModel: IViewModeling {
    // MARK: - Input
    
    struct Input {
        let bag: DisposeBag
    }
    
    // MARK: - Output
    
    struct Output {
        let isLoading: Driver<Bool>
        let cocktailsList: Driver<DrinksDetail?>
    }
    
    func transform(input: Input, outputHandler: (Output) -> Void) {
        
        let isLoading = self.isLoading.asDriver(onErrorDriveWith: .empty())
        
        let cocktailsDetail = self.cocktailsDetail.asDriver(onErrorDriveWith: .empty())
        
        outputHandler(.init(isLoading: isLoading, cocktailsList: cocktailsDetail))
    }
}

extension CocktailsDetailViewModel {
    
    func getCocktailList(id: String) {
        isLoading.accept(true)
        getCocktailsDetailApi(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.cocktailsDetail.accept(item.drinks.first)
                self?.isLoading.accept(false)
                print(item)
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                print(error)
            })
            .disposed(by: bag)
    }
    
    func getCocktailsDetailApi(id: String) -> Observable<DrinksDetailList> {
        return ApiClient.shared.request(ApiRouter.cocktailDetail(id: id))
    }
}

extension CocktailsDetailViewModel: DIConfigurable {
    struct Container {
        let routes: CocktailsDetailRouter
        let detailID: String
    }
}
