//
//  AlertViewController.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import UIKit

public class AlertViewController: UIViewController {
    
    var didTapRetry: (() -> Void)?
    
    private let overlayView: UIView = {
        $0.backgroundColor = UIColor.appColor(.overlay)
        return $0
    }(UIView())
    
    private let containerView: UIView = {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = UIColor.appColor(.background)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let imageView: UIImageView = {
        $0.image = AssetsImage.Common.error.image
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.textColor = UIColor.appColor(.titleColor)
        $0.text = "Error occured"
        $0.textAlignment = .center
        $0.font = .regular(fontSize: 20)
        return $0
    }(UILabel())
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = UIColor.appColor(.yellow)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 24
        return stackView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
        [stackView, retryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        view.addSubview(overlayView)
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(198)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        retryButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(31)
            make.width.equalTo(164)
        }
    }
    
    @objc private func retry() {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = .clear
            self.containerView.alpha = 0.0
            self.overlayView.alpha = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
            self.didTapRetry?()
        }
    }
}
