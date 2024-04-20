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
    
    //MARK: - Private properties
    
    let viewModel: HomeViewModel
    private var isAlcoholic = BehaviorRelay<Bool?>(value: false)
    private var drinksDetail = BehaviorRelay<String?>(value: nil)
    private var cocktailsList: [Drink] = []
    
    //MARK: - UI Elements
    
    private let segmentedControl = SSSegmentedControl()
    private let searchBar = SearchBarView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = .init(width: 180, height: 175)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.register(GridCell.self, forCellWithReuseIdentifier: "cellId")
        return view
    }()
    
    required init(container: Container) {
        self.viewModel = container.viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBinding()
    }
}

// MARK: - IViewModelOwner

extension HomeViewController: IViewModelOwner {
    
    func createInput() {
        let filterTrigger = isAlcoholic.asSignal(onErrorJustReturn: false)
        let drinksDetail = drinksDetail.asSignal(onErrorJustReturn: nil)
        let input = HomeViewModel.Input(bag: bag, isAlhocolic: filterTrigger, drinksDetail: drinksDetail)
        viewModel.transform(input: input, outputHandler: subscribeToOutput(_:))
    }
    
    func subscribeToOutput(_ output: HomeViewModel.Output) {
        output.cocktailsList.drive { [weak self] list in
            self?.cocktailsList = list
            self?.collectionView.reloadData()
        }.disposed(by: bag)
        
        output.isLoading.drive { [weak self] isLoading in
            isLoading ? self?.showLoader() : self?.hideLoader()
        }.disposed(by: bag)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cocktailsList.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! GridCell
        loadImageFromURL(urlString: self.cocktailsList[indexPath.row].strDrinkThumb) { image in
            if let image = image {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    cell.configure(title: self.cocktailsList[indexPath.row].strDrink, image: image)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        drinksDetail.accept(self.cocktailsList[indexPath.row].idDrink)
    }
}

extension HomeViewController {
    private func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Cocktails"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.regular(fontSize: 30), NSAttributedString.Key.foregroundColor: UIColor.appColor(.titleColor)]

        [searchBar, segmentedControl, collectionView].forEach {
            view.addSubview($0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalTo(UIScreen.main.bounds.width - 20)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalTo(UIScreen.main.bounds.width - 20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupBinding() {
        searchBar.didTextFieldChange = { [weak self] textField in
            print(textField.text)
        }
        
        segmentedControl.didTapSegment = { [weak self] index in
            index == 0 ? self?.isAlcoholic.accept(false) : self?.isAlcoholic.accept(true)
        }
    }
}

// MARK: - DIConfigurable
extension HomeViewController: DIConfigurable {
    struct Container {
        let viewModel: HomeViewModel
    }
}
