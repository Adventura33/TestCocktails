//
//  File.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation

protocol IViewModeling {
    associatedtype Input
    associatedtype Output

    func transform(input: Input, outputHandler: (_ output: Output) -> Void)
}
