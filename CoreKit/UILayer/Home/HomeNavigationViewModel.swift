//
//  HomeNavigationViewModel.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//


import Foundation
import Combine

public class HomeNavigationViewModel: MovieDetailsNavigator {

    // MARK: - Properties
    
    @Published public var view: HomeView

    // MARK: - Methods
    
    public init() {
        view = .root
    }
    
    public func navigateToMovieDetails(
        with id: Int,
        responder: ToggledWatchlistResponder
    ) {
        view = .details(id: id, responder: responder)
    }

}

public protocol MovieDetailsNavigator {
    func navigateToMovieDetails(
        with id: Int,
        responder: ToggledWatchlistResponder
    )
}
