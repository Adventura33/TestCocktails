//
//  GridCell.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 19.04.2024.
//

import Foundation
import UIKit

class GridCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    private let containerView: UIView = {
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.textAlignment = .center
        $0.textColor = UIColor.appColor(.white)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        addSubview(containerView)
    }
    
    func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    func configure(title: String, image: String) {
        titleLabel.text = title
        loadImageFromURL(urlString: image) { image in
            if let image = image {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    imageView.image = image
                }
            }
        }
    }
    
    func loadImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
}
