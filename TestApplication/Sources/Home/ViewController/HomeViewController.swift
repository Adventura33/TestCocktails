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
    private var nonAlcoholicCocktailsList: [Drink] = []
    private var alcoholicCocktailsList: [Drink] = []
    private var allList: [Drink] = []
    private var segmentIndex: Int = 0
    
    //MARK: - UI Elements
    
    private let segmentedControl = SSSegmentedControl()
    private let searchBar = SearchBarView()
    
    private lazy var refreshControl: UIRefreshControl = {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return $0
    }(UIRefreshControl())
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaultsManager.clearLists()
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
        output.nonAlcoholicCocktailsList.drive { [weak self] list in
            UserDefaultsManager.saveNonAlcoholicList(list)
            self?.allList.append(contentsOf: list)
            self?.nonAlcoholicCocktailsList = list
            self?.collectionView.reloadData()
        }.disposed(by: bag)
        
        output.alcoholicCocktailsList.drive { [weak self] list in
            UserDefaultsManager.saveAlcoholicList(list)
            self?.allList.append(contentsOf: list)
            self?.alcoholicCocktailsList = list
            self?.collectionView.reloadData()
        }.disposed(by: bag)
        
        output.showAlert.drive { [weak self] _ in
            self?.showAlert(completion: {
                self?.segmentIndex == 0 ? self?.isAlcoholic.accept(false) : self?.isAlcoholic.accept(true)
            })
        }.disposed(by: bag)
        
        output.isLoading.drive { [weak self] isLoading in
            isLoading ? self?.showLoader() : self?.hideLoader()
        }.disposed(by: bag)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentIndex == 0 ? self.nonAlcoholicCocktailsList.count : self.alcoholicCocktailsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! GridCell
        segmentIndex == 0 ? cell.configure(title: self.nonAlcoholicCocktailsList[indexPath.row].strDrink, image: self.nonAlcoholicCocktailsList[indexPath.row].strDrinkThumb) : cell.configure(title: self.alcoholicCocktailsList[indexPath.row].strDrink, image: self.alcoholicCocktailsList[indexPath.row].strDrinkThumb)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        segmentIndex == 0 ?  drinksDetail.accept(self.nonAlcoholicCocktailsList[indexPath.row].idDrink) : drinksDetail.accept(self.alcoholicCocktailsList[indexPath.row].idDrink)
    }
}

// MARK: - Actions

extension HomeViewController {
    @objc func refreshData() {
        segmentIndex == 0 ? nonAlcoholicCocktailsList.shuffle() : alcoholicCocktailsList.shuffle()
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension HomeViewController {
    private func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Cocktails"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.regular(fontSize: 30), NSAttributedString.Key.foregroundColor: UIColor.appColor(.titleColor)]
        
        collectionView.refreshControl = refreshControl

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
            guard let self = self, let text = textField.text else { return }
            if text.isEmpty {
                let list = self.segmentIndex == 0 ? UserDefaultsManager.loadNonAlcoholicList() : UserDefaultsManager.loadAlcoholicList()
                if self.segmentIndex == 0 {
                    self.nonAlcoholicCocktailsList = list
                } else {
                    self.alcoholicCocktailsList = list
                }
            } else {
                let savedCocktails = self.segmentIndex == 0 ? UserDefaultsManager.loadNonAlcoholicList() : UserDefaultsManager.loadAlcoholicList()
                let filteredCocktails = savedCocktails.filter { $0.strDrink.lowercased().contains(text.lowercased()) }
                if self.segmentIndex == 0 {
                    self.nonAlcoholicCocktailsList = filteredCocktails
                } else {
                    self.alcoholicCocktailsList = filteredCocktails
                }
            }
            self.collectionView.reloadData()
        }
        
        segmentedControl.didTapSegment = { [weak self] index in
            self?.nonAlcoholicCocktailsList = UserDefaultsManager.loadNonAlcoholicList()
            self?.alcoholicCocktailsList = UserDefaultsManager.loadAlcoholicList()
            self?.searchBar.clearSearchText()
            self?.segmentIndex = index
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - DIConfigurable
extension HomeViewController: DIConfigurable {
    struct Container {
        let viewModel: HomeViewModel
    }
}
