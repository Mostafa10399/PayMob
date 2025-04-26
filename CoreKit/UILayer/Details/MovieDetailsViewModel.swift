//
//  MovieDetailsViewModel.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//


import Foundation
import Combine

public final class MovieDetailsViewModel {
    
    // MARK: - Properties
    
    private let repository: MovieDetailsRepository
    private let id: Int
    private let responder: ToggledWatchlistResponder
    private let movieDetailsSubject = PassthroughSubject<MovieDetailsPresentable, Never>()
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    public var list: AnyPublisher<MovieDetailsPresentable, Never> {
        movieDetailsSubject.eraseToAnyPublisher()
    }
    public var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    public var errorMessagesPublisher: AnyPublisher<ErrorMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    public let errorPresentation = CurrentValueSubject<ErrorPresentation?, Never>(nil)

    // State
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    
    public init(
        withId id: Int,
        repository: MovieDetailsRepository,
        responder: ToggledWatchlistResponder
    ) {
        self.repository = repository
        self.id = id
        self.responder = responder
    }
    
    public func getData() {
        Task { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingSubject.send(true)
            defer { strongSelf.isLoadingSubject.send(false) }
            do {
                let movieDetails = try await strongSelf.repository.getMovieDetails(withId: strongSelf.id)
                let presentableDetails = MovieDetailsPresentable(movieDetails)
                await MainActor.run {
                    print(presentableDetails)
                    strongSelf.movieDetailsSubject.send(presentableDetails)
                }
            } catch {
                await MainActor.run {
                    strongSelf.errorMessagesSubject.send(ErrorMessage(error: error))
                }
            }
        }
    }

    // MARK: - Actions
    
    @objc
    public func toggleWatchlist() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let isInWatchlist = try await self.repository.toggleWatchlist(for: self.id)
                self.responder.didToggleWatchlist(for: self.id)
                let updatedMovieDetails = try await self.repository.getMovieDetails(withId: self.id)
                let updatedPresentable = MovieDetailsPresentable(updatedMovieDetails)
                    self.movieDetailsSubject.send(updatedPresentable)
            } catch {
                await MainActor.run {
                    self.errorMessagesSubject.send(ErrorMessage(error: error))
                }
            }
        }
    }


}
