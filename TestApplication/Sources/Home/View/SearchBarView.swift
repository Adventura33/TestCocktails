//
//  SearchBarView.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import UIKit

class SearchBarView: UIView {
    
    var didTextFieldChange: ((UITextField) -> Void)?
    
    let searchTextField = UITextField()
    let clearButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.appColor(.lightDark)
        layer.cornerRadius = 12
        setupSearchTextField()
        setupClearButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchTextField() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appColor(.secondaryText)
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
        searchTextField.attributedPlaceholder = attributedPlaceholder
        searchTextField.borderStyle = .none
        searchTextField.delegate = self
        searchTextField.textColor = UIColor.appColor(.titleColor)
        searchTextField.leftView = UIImageView(image: AssetsImage.Common.search.image)
        searchTextField.leftViewMode = .always
        searchTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupClearButton() {
        clearButton.setImage(AssetsImage.Common.close.image, for: .normal)
        clearButton.addTarget(self, action: #selector(clearSearchText), for: .touchUpInside)
        clearButton.isHidden = true
        addSubview(clearButton)
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalTo(searchTextField)
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    @objc func clearSearchText() {
        searchTextField.text = ""
        clearButton.isHidden = true
        searchTextField.resignFirstResponder()
    }
}

extension SearchBarView: UITextFieldDelegate {
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = false
    }
    
    @objc func textChanged(_ textField: UITextField) {
        didTextFieldChange?(textField)
    }
}
