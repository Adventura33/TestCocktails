//
//  File.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation

protocol DIConfigurable {
    associatedtype Container

    init(container: Container)
}
