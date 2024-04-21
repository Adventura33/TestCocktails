//
//  CocktailsDetailViewController.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Swinject
import SnapKit

final class CocktailsDetailViewController: BaseController<CocktailsDetailCoordinator>, IAutoSetup {
    
    let viewModel: CocktailsDetailViewModel
    
    //MARK: - Private properties
    private var isRetry = BehaviorRelay<Bool?>(value: false)
    
    //MARK: - UI Elements
    
    private let topView = UIView()
    private let bottomView = UIView()
    private let imageView = UIImageView()
    private let categoryIcon = UIImageView()

    private lazy var backButton = UIBarButtonItem(image: AssetsImage.Common.back.image, style: .plain, target: self, action: #selector(closeTapped))
    
    private let categoryView: UIView = {
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.appColor(.lightDark)
        return $0
    }(UIView())
    
    private let typeView: UIView = {
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.appColor(.lightDark)
        return $0
    }(UIView())
    
    private let categoryLabel: UILabel = {
        $0.font = .regular(fontSize: 16)
        $0.textColor = UIColor.appColor(.yellow)
        return $0
    }(UILabel())
    
    private let typeLabel: UILabel = {
        $0.font = .regular(fontSize: 16)
        $0.textColor = UIColor.appColor(.third)
        return $0
    }(UILabel())
    
    private let titleLabel: UILabel = {
        $0.font = .regular(fontSize: 30)
        $0.textColor = UIColor.appColor(.titleColor)
        return $0
    }(UILabel())
    
    private let instructionLabel: UILabel = {
        $0.font = .regular(fontSize: 24)
        $0.textColor = UIColor.appColor(.yellow)
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = .regular(fontSize: 16)
        $0.textColor = UIColor.appColor(.titleColor)
        return $0
    }(UILabel())
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryView, typeView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
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
    }
}

// MARK: - IViewModelOwner

extension CocktailsDetailViewController: IViewModelOwner {
    
    func createInput() {
        let retryTrigger = isRetry.asSignal(onErrorJustReturn: false)
        let input = CocktailsDetailViewModel.Input(bag: bag, isRetry: retryTrigger)
        viewModel.transform(input: input, outputHandler: subscribeToOutput(_:))
    }
    
    func subscribeToOutput(_ output: CocktailsDetailViewModel.Output) {
        output.cocktailsList.drive { [weak self] item in
            guard let item = item else { return }
            self?.configure(item: item)
        }.disposed(by: bag)
        
        output.showAlert.drive { [weak self] _ in
            self?.showAlert(completion: {
                self?.isRetry.accept(true)
            })
        }.disposed(by: bag)
        
        output.isLoading.drive { [weak self] isLoading in
            isLoading ? self?.showLoader() : self?.hideLoader()
        }.disposed(by: bag)
    }
}

// MARK: - Methods

extension CocktailsDetailViewController {
    @objc func closeTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CocktailsDetailViewController {
    private func setupViews() {
        self.navigationItem.leftBarButtonItem = backButton
        [imageView, titleLabel].forEach {
            topView.addSubview($0)
        }
        
        [hStackView, instructionLabel, descriptionLabel].forEach {
            bottomView.addSubview($0)
        }
        typeView.addSubview(typeLabel)
        categoryView.addSubview(categoryIcon)
        categoryView.addSubview(categoryLabel)
        
        view.addSubview(bottomView)
        view.addSubview(topView)
    }
    
    private func setupConstraints() {
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(375)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        categoryIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.left.equalToSuperview().offset(8)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(categoryIcon.snp.right).offset(5)
            make.right.equalToSuperview()
        }
        
        hStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        categoryView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(categoryLabel.textWidth())
        }
        
        typeView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(typeLabel.textWidth())
        }
        
        typeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    func configure(item: DrinksDetail) {
        categoryLabel.text = item.strCategory
        typeLabel.text = item.strAlcoholic
        titleLabel.text = item.strDrink
        instructionLabel.text = "Instruction"
        descriptionLabel.text = item.strInstructions
        if let imageUrl = item.strDrinkThumb {
            loadImageFromURL(urlString: imageUrl) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        
        if let category = item.strCategory {
            switch DetailCategory(rawValue: category) {
            case .some(let category):
                categoryIcon.image = category.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
            case .none:
                categoryIcon.image = AssetsImage.CocktailsType.cocktail.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
            }
        }
        
        typeView.snp.remakeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(typeLabel.textWidth() + 24)
        }
        
        categoryView.snp.remakeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(categoryLabel.textWidth() + 54)
        }
    }
}

// MARK: - DIConfigurable
extension CocktailsDetailViewController: DIConfigurable {
    struct Container {
        let viewModel: CocktailsDetailViewModel
    }
}
