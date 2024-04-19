//
//  AppDelegate.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppCoordinator(resolver: AppDependencyManager.shared.resolver, delegate: self).start()
        return true
    }
}

