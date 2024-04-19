//
//  IViewModelOwner.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 18.04.2024.
//

import Foundation

protocol IViewModelOwner {
    associatedtype ViewModel: IViewModeling

    var viewModel: ViewModel { get }

    func createInput()
    func subscribeToOutput(_ output: ViewModel.Output)
}
