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
    private let alcoholicCocktailsList = BehaviorRelay<[Drink]>(value: [])
    private let nonAlcoholicCocktailsList = BehaviorRelay<[Drink]>(value: [])
    private let isLoading = PublishRelay<Bool>()
    private let showAlert = PublishRelay<Bool>()
    
    // MARK: - Init
    required init(container: Container) {
        self.routes = container.routes
        fetch()
    }
    
    func fetch() {
        getNonAlcoholicCocktailList()
        getAlcoholicCocktailList()
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
        let alcoholicCocktailsList: Driver<[Drink]>
        let nonAlcoholicCocktailsList: Driver<[Drink]>
        let showAlert: Driver<Bool>
    }
    
    func transform(input: Input, outputHandler: (Output) -> Void) {
        
        subscribeFilter(input.isAlhocolic)
            .disposed(by: input.bag)
        
        subscribeDetail(input.drinksDetail)
            .disposed(by: input.bag)
        
        let isLoading = self.isLoading.asDriver(onErrorDriveWith: .empty())
        
        let alcoholicCocktailsList = self.alcoholicCocktailsList.asDriver(onErrorDriveWith: .empty())
        
        let nonAlcoholicCocktailsList = self.nonAlcoholicCocktailsList.asDriver(onErrorDriveWith: .empty())
        
        let showAlert = self.showAlert.asDriver(onErrorDriveWith: .empty())
        
        outputHandler(.init(isLoading: isLoading, alcoholicCocktailsList: alcoholicCocktailsList, nonAlcoholicCocktailsList: nonAlcoholicCocktailsList, showAlert: showAlert))
    }
}

extension HomeViewModel {
    
    func subscribeDetail(_ trigger: Signal<String?>) -> Disposable {
        return trigger.emit(onNext: { [weak self] id in
            guard let id = id else { return }
            self?.routes.openDetail(with: id)
        })
    }
    
    func subscribeFilter(_ trigger: Signal<Bool?>) -> Disposable {
        return trigger.emit(onNext: { [weak self] filter in
            guard let filter = filter else { return }
            filter == true ? self?.getAlcoholicCocktailList() : self?.getNonAlcoholicCocktailList()
        })
    }
    
    func getAlcoholicCocktailList() {
        isLoading.accept(true)
        getCocktailListApi(isAlcoholic: true)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.alcoholicCocktailsList.accept(list.drinks)
                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.showAlert.accept(true)
            })
            .disposed(by: bag)
    }
    
    func getNonAlcoholicCocktailList() {
        isLoading.accept(true)
        getCocktailListApi(isAlcoholic: false)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.nonAlcoholicCocktailsList.accept(list.drinks)
                self?.isLoading.accept(false)
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
