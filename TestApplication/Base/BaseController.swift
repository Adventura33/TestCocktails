//
//  BaseController.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation
import UIKit
import RxSwift

class BaseController<CoordinatorType: ICoordinator>: UIViewController {

    let bag = DisposeBag()

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

        performSetupIfNeeded()
    }

    private func performSetupIfNeeded() {
        guard let setuper = self as? IAutoSetup, setuper.shouldSetupAutomatically else {
            return
        }
        setuper.performAutoSetup()
    }
}
