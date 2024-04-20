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

class BaseController<CoordinatorType: ICoordinator>: UIViewController {

    let bag = DisposeBag()
    let motionManager = CMMotionManager()
    
    var loaderView: MainLoaderView?

    var coordinator: CoordinatorType?

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
        view.backgroundColor = UIColor.appColor(.background)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Cocktails"
        
        performSetupIfNeeded()
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            toggleTheme()
        }
    }
    
    func toggleTheme() {
        if #available(iOS 13.0, *) {
            let currentTraitCollection = self.traitCollection
            let userInterfaceStyle = currentTraitCollection.userInterfaceStyle
            let newStyle: UIUserInterfaceStyle = userInterfaceStyle == .dark ? .light : .dark
            self.overrideUserInterfaceStyle = newStyle
        }
    }
}
