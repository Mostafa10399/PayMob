//
//  HomeViewController.swift
//  PayMob-Task
//
//  Created by Mostafa on 25/04/2025.
//


import UIKit
import CoreKit
import AppUIKit
import Combine

final class HomeViewController: NiblessNavigationController {
    
    // MARK: - Properties
    
    private let viewModel: HomeNavigationViewModel
    private let rootViewController: HomeRootViewController
    private var cancelable: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    init(
        viewModel: HomeNavigationViewModel,
        rootViewController: HomeRootViewController
    ) {
        self.viewModel = viewModel
        self.rootViewController = rootViewController
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
        viewControllers = [rootViewController]
    }
    
    private func observeViewModel() {
        let publisher = viewModel.$view.eraseToAnyPublisher()
        subscriber(to: publisher)
    }
    
    private func subscriber(to publisher: AnyPublisher<HomeView, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] view in
                guard let strongSelf = self else {return}
                strongSelf.present(view)
            }
            .store(in: &cancelable)
    }
    
    private func present(_ view: HomeView) {
        switch view {
        case .root:
            print("id")
            presentHomeRootView()
        case let .details(id, responder):
            print(id)
        }
    }
    
    private func presentHomeRootView() {
        popToRootViewController(animated: false)
    }

}
