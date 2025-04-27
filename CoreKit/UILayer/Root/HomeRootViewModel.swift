//
//  HomeRootViewModel.swift
//  CoreKit
//
//  Created by Mostafa on 26/04/2025.
//

import Foundation
import Combine
import UIKit

public final class HomeRootViewModel: GetMoviesUsecase {
    
    // MARK: - Properties
    
    internal let repository: MovieRepository
    private let navigator: MovieDetailsNavigator
    public let currentDisplayedItemSubject = PassthroughSubject<Int, Never>()
    private let popularMoviesSubject = CurrentValueSubject<[MovieListPresentable], Never>([])
    private var canLoadMore = true
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    public let errorPresentation = CurrentValueSubject<ErrorPresentation?, Never>(nil)
    public let selectItemSubject = PassthroughSubject<IndexPath, Never>()
    private var page: Int = 1
    
    public var list: AnyPublisher<[MovieListPresentable], Never> {
        popularMoviesSubject.eraseToAnyPublisher()
    }
    public var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    public var errorMessagesPublisher: AnyPublisher<ErrorMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    public var selectedItemSubscriber: AnySubscriber<IndexPath, Never> {
        AnySubscriber(selectItemSubject)
    }
    
    private var cancelables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    public init(
        repository: MovieRepository,
        navigator: MovieDetailsNavigator
    ) {
        self.repository = repository
        self.navigator = navigator
        self.fetchHomeData()
        self.subscribeToSelectItem()
        subscribeToLoadMore()
    }
    
    private func fetchHomeData() {
        Task { [weak self] in
            guard let strongSelf = self else { return }
            defer { strongSelf.isLoadingSubject.send(false) }
            if strongSelf.canLoadMore {
                strongSelf.isLoadingSubject.send(true)
                do {
                    let newMovies = try await strongSelf.getMovies(page: strongSelf.page)
                    await MainActor.run {
                        var currentMovies = strongSelf.popularMoviesSubject.value
                        let newUniqueMovies = newMovies.filter { newMovie in
                            !currentMovies.contains(where: { $0.id == newMovie.id })
                        }
                        currentMovies.append(contentsOf: newUniqueMovies)
                        strongSelf.popularMoviesSubject.send(currentMovies)
                        strongSelf.page += 1
                        strongSelf.canLoadMore = !newUniqueMovies.isEmpty
                    }
                } catch {
                    await MainActor.run {
                        strongSelf.errorMessagesSubject.send(ErrorMessage(error: error))
                    }
                }
            }
        }
    }
    
    private func subscribeToSelectItem() {
        selectItemSubject
            .sink { [weak self] indexPath in
                guard let strongSelf = self else { return }
                let selectedMovie = strongSelf.popularMoviesSubject.value[indexPath.row]
                strongSelf.navigator.navigateToMovieDetails(with: selectedMovie.id, responder: strongSelf)
            }
            .store(in: &cancelables)
    }
    
    private func subscribeToLoadMore() {
        currentDisplayedItemSubject
            .filter { $0 > 0 }
            .filter { [weak self] index in
                guard let strongSelf = self else { return false }
                return (strongSelf.popularMoviesSubject.value.count - 2) == index
            }
            .sink { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.fetchHomeData()
            }
            .store(in: &cancelables)
    }
    
}

extension HomeRootViewModel: ToggledWatchlistResponder {
    public func didToggleWatchlist(for id: Int) {
        var movies = popularMoviesSubject.value
        if let index = movies.firstIndex(where: { $0.id == id }) {
            movies[index].isInWatchlist.toggle()
            popularMoviesSubject.send(movies)
        }
    }}
