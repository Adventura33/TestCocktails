//
//  BaseController.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import UIKit
import RxSwift
import CoreMotion

class BaseController: UIViewController {

    let bag = DisposeBag()
    let motionManager = CMMotionManager()
    
    var loaderView: MainLoaderView?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("💀: View Controller \(self) deinited")
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not available")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        performSetupIfNeeded()
        updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func showLoader() {
        if loaderView == nil {
            loaderView = MainLoaderView()
        }
        
        if let loaderView = loaderView, !view.subviews.contains(loaderView) {
            view.addSubview(loaderView)
            
            loaderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        self.loaderView?.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideLoader() {
        loaderView?.stopAnimating()
        view.isUserInteractionEnabled = true
        loaderView?.removeFromSuperview()
        loaderView = nil
    }

    private func performSetupIfNeeded() {
        guard let setuper = self as? IAutoSetup, setuper.shouldSetupAutomatically else {
            return
        }
        setuper.performAutoSetup()
    }
    
    func updateTheme() {
        var titleColor: UIColor
        overrideUserInterfaceStyle = ThemeManager.shared.currentTheme
        titleColor = ThemeManager.shared.currentTheme == .dark ? .white : .black
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.regular(fontSize: 30),
            NSAttributedString.Key.foregroundColor: titleColor
        ]
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            ThemeManager.shared.changeTheme()
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
    
    func showAlert(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let vc = AlertViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.didTapRetry = {
                completion()
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}
