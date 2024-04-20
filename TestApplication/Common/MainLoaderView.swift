//
//  MainLoaderView.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 20.04.2024.
//

import Foundation
import UIKit
import Lottie

final class MainLoaderView: UIView {
    
    private let lottieView = LottieAnimationView(name: "cocktail_animation")
    
    private let overlayView: UIView = {
        $0.backgroundColor = UIColor.appColor(.overlay)
        return $0
    }(UIView())
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        isUserInteractionEnabled = false
        addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 1.0
        }
        addSubview(lottieView)
        lottieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
        lottieView.play()
        lottieView.loopMode = .loop
    }

    func stopAnimating() {
        UIView.animate(withDuration: 0.5) {
               self.overlayView.alpha = 0.0
           }
        lottieView.stop()
        overlayView.removeFromSuperview()
        isUserInteractionEnabled = true
    }
}
