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
        let movieDetailsViewControllerFactory = { (id: Int, responder: ToggledWatchlistResponder) -> MovieDetailsViewController in
            let viewModel = self.makeMovieDetailsViewModel(id: id, responder: responder)
            return self.makeMovieDetailsViewController(viewModel: viewModel)
        }
        
        return HomeViewController(
            viewModel: sharedHomeViewModel,
            rootViewController: makeRootViewController(),
            movieDetailsViewControllerFactory: movieDetailsViewControllerFactory
        )
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
    
    private func makeMovieDetailsViewModel(
        id: Int,
        responder: ToggledWatchlistResponder
    ) -> MovieDetailsViewModel {
        MovieDetailsViewModel(
            withId: id,
            repository: makeMovieDetailsRepository(),
            responder: responder
        )
    }
    
    private func makeMovieDetailsViewController(viewModel: MovieDetailsViewModel) -> MovieDetailsViewController {
        MovieDetailsViewController(view: MovieDetailsView(), viewModel: viewModel)
    }

    // Repositories
    
    private func makeMoviesRepository() -> MovieRepository {
        DefaultMovieRepositoryImpelemetion(
            remoteAPI: MDBMovieAPI(),
            userSessionDataStore: XCConfigUserSessionDataStore(),
            watchlistDataStore: UserDefaultWatchlistDataStore()
        )
    }
    
    private func makeMovieDetailsRepository() -> MovieDetailsRepository {
        DefaultMovieDetailsRepositoryImpelementation(
            remoteAPI: MDBMovieAPI(),
            userSessionDataStore: XCConfigUserSessionDataStore(),
            watchlistDataStore: UserDefaultWatchlistDataStore()
        )
    }

}
