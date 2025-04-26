//
//  HomeDependencyContainer.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//


import Foundation
import CoreKit
import AppUIKit

final class HomeDependencyContainer {
    
    // MARK: - Properties
        
    // Long-lived dependencies
    private let sharedHomeViewModel: HomeNavigationViewModel

    init() {
        func makeHomeViewModel() -> HomeNavigationViewModel {
            return HomeNavigationViewModel()
        }
        
        self.sharedHomeViewModel = makeHomeViewModel()
    }
    
    public func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: sharedHomeViewModel,
                                  rootViewController: makeRootViewController())
    }
    
    // Root
    
    private func makeRootViewController() -> HomeRootViewController {
        HomeRootViewController(
            view: makeHomeRootView(),
            viewModel: makeHomeRootViewModel()
        )
    }
    
    private func makeHomeRootView() -> HomeRootView {
        HomeRootView()
    }

    
    private func makeHomeRootViewModel() -> HomeRootViewModel {
        HomeRootViewModel(repository: makeMoviesRepository(), navigator: sharedHomeViewModel)
    }

    // Repositories
    
    private func makeMoviesRepository() -> MovieRepository {
        DefaultMovieRepositoryImpelemetion(remoteAPI: MDBMovieAPI(), userSessionDataStore: XCConfigUserSessionDataStore(), watchlistDataStore: UserDefaultWatchlistDataStore())
    }

}
