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
    private let showAlert = PublishRelay<Bool>()
    
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
        let isRetry: Signal<Bool?>
    }
    
    // MARK: - Output
    
    struct Output {
        let isLoading: Driver<Bool>
        let cocktailsList: Driver<DrinksDetail?>
        let showAlert: Driver<Bool>
    }
    
    func transform(input: Input, outputHandler: (Output) -> Void) {
        
        subscribeRetry(input.isRetry)
            .disposed(by: input.bag)
        
        let isLoading = self.isLoading.asDriver(onErrorDriveWith: .empty())
        
        let cocktailsDetail = self.cocktailsDetail.asDriver(onErrorDriveWith: .empty())
        
        let showAlert = self.showAlert.asDriver(onErrorDriveWith: .empty())
        
        outputHandler(.init(isLoading: isLoading, cocktailsList: cocktailsDetail, showAlert: showAlert))
    }
}

extension CocktailsDetailViewModel {
    
    func subscribeRetry(_ trigger: Signal<Bool?>) -> Disposable {
        return trigger.emit(onNext: { [weak self] _ in
            guard let id = self?.detailId else { return }
            self?.getCocktailList(id: id)
        })
    }
    
    func getCocktailList(id: String) {
        isLoading.accept(true)
        getCocktailsDetailApi(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.cocktailsDetail.accept(item.drinks.first)
                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.showAlert.accept(true)
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
