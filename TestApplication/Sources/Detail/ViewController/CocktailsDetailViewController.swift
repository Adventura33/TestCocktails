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

class CocktailsDetailViewController: BaseController<CocktailsDetailCoordinator>, IAutoSetup {
    
    //MARK: - Private properties
    
    let viewModel: CocktailsDetailViewModel
    
    //MARK: - UI Elements
    
    private lazy var backButton: UIButton = {
        $0.setImage(AssetsImage.Common.back.image, for: .normal)
        $0.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let topView = UIView()
    private let bottomView = UIView()
    private let imageView = UIImageView()
    
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
    
    private let categoryIcon = UIImageView()
    
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
        let input = CocktailsDetailViewModel.Input(bag: bag)
        viewModel.transform(input: input, outputHandler: subscribeToOutput(_:))
    }
    
    func subscribeToOutput(_ output: CocktailsDetailViewModel.Output) {
        output.cocktailsList.drive { [weak self] item in
            guard let item = item else { return }
            self?.configure(item: item)
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
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        [imageView, titleLabel, backButton].forEach {
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
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.left.equalToSuperview().offset(10)
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
        loadImageFromURL(urlString: item.strDrinkThumb ?? "") { image in
            if let image = image {
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
        
        switch item.strCategory {
        case "Shake":
            categoryIcon.image = AssetsImage.CocktailsType.smoothieShake.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        case "Beer":
            categoryIcon.image = AssetsImage.CocktailsType.beer.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        case "Shot":
            categoryIcon.image = AssetsImage.CocktailsType.shot.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        case "Punch / Party Drink":
            categoryIcon.image = AssetsImage.CocktailsType.drinkOnTheParty.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        case "Ordinary Drink":
            categoryIcon.image = AssetsImage.CocktailsType.softDrink.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        case "Coffee / Tea":
            categoryIcon.image = AssetsImage.CocktailsType.coffee.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        case "Homemade Liqueur":
            categoryIcon.image = AssetsImage.CocktailsType.liquor.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        case "Other / Unknown":
            categoryIcon.image = AssetsImage.CocktailsType.other.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
        default:
            categoryIcon.image = AssetsImage.CocktailsType.cocktail.image.tint(with: UIColor.appColor(.yellow) ?? UIColor())
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
