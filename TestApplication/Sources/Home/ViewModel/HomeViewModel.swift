//
//  HomeViewModel.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    
    //MARK: - Private Properties
    private let routes: HomeRouter
    private let bag = DisposeBag()
    
    private let isAlcoholic = BehaviorRelay<Bool>(value: true)
    private let cocktailsList = BehaviorRelay<[Drink]>(value: [])
    private let isLoading = PublishRelay<Bool>()
    private let showAlert = PublishRelay<Bool>()
    
    // MARK: - Init
    required init(container: Container) {
        self.routes = container.routes
        fetch()
    }
    
    func fetch() {
        self.getCocktailList(isAlcoholic: false)
    }
}

// MARK: - IViewModeling
extension HomeViewModel: IViewModeling {
    // MARK: - Input
    
    struct Input {
        let bag: DisposeBag
        let isAlhocolic: Signal<Bool?>
        let drinksDetail: Signal<String?>
    }
    
    // MARK: - Output
    
    struct Output {
        let isLoading: Driver<Bool>
        let cocktailsList: Driver<[Drink]>
        let showAlert: Driver<Bool>
    }
    
    func transform(input: Input, outputHandler: (Output) -> Void) {
        
        subscribeFilter(input.isAlhocolic)
            .disposed(by: input.bag)
        
        subscribeDetail(input.drinksDetail)
            .disposed(by: input.bag)
        
        let isLoading = self.isLoading.asDriver(onErrorDriveWith: .empty())
        
        let cocktailsList = self.cocktailsList.asDriver(onErrorDriveWith: .empty())
        
        let showAlert = self.showAlert.asDriver(onErrorDriveWith: .empty())
        
        outputHandler(.init(isLoading: isLoading, cocktailsList: cocktailsList, showAlert: showAlert))
    }
}

extension HomeViewModel {
    
    func subscribeDetail(_ trigger: Signal<String?>) -> Disposable {
        return trigger.emit(onNext: { [weak self] id in
            guard let id = id else { return }
            self?.routes.openDetail(id: id)
        })
    }
    
    func subscribeFilter(_ trigger: Signal<Bool?>) -> Disposable {
        return trigger.emit(onNext: { [weak self] filter in
            guard let filter = filter else { return }
            self?.getCocktailList(isAlcoholic: filter)
        })
    }
    
    func getCocktailList(isAlcoholic: Bool) {
        isLoading.accept(true)
        getCocktailListApi(isAlcoholic: isAlcoholic)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.cocktailsList.accept(list.drinks)
                self?.isLoading.accept(false)
                print(list)
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.showAlert.accept(true)
            })
            .disposed(by: bag)
    }
    
    func getCocktailListApi(isAlcoholic: Bool) -> Observable<CocktailsList> {
        return ApiClient.shared.request(ApiRouter.filterCocktailsByAlcoholic(isAlcoholic: isAlcoholic))
    }
}

extension HomeViewModel: DIConfigurable {
    struct Container {
        let routes: HomeRouter
    }
}
