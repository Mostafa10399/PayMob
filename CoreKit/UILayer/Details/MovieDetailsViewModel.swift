//
//  MovieDetailsViewModel.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//


import Foundation
import Combine

public final class MovieDetailsViewModel: GetMovieDetailsUsecase {
    
    // MARK: - Properties
    
    internal var repository: MovieDetailsRepository
    private let id: Int
    private let responder: ToggledWatchlistResponder
    private let movieDetailsSubject = CurrentValueSubject<MovieDetailsPresentable?, Never>(nil)
    private let errorMessagesSubject = PassthroughSubject<ErrorMessage, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    public var list: AnyPublisher<MovieDetailsPresentable?, Never> {
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
                let movieDetails = try await strongSelf.getMovieDetails(with: strongSelf.id)
                await MainActor.run {
                    strongSelf.movieDetailsSubject.send(movieDetails)
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
            guard let strongSelf = self else { return }
            do {
                let isInWatchlist = try await strongSelf.repository.toggleWatchlist(for: strongSelf.id)
                strongSelf.responder.didToggleWatchlist(for: strongSelf.id)
                guard var movie = strongSelf.movieDetailsSubject.value else { return }
                movie.isInWatchlist = isInWatchlist
                strongSelf.movieDetailsSubject.send(movie)
            } catch {
                await MainActor.run {
                    strongSelf.errorMessagesSubject.send(ErrorMessage(error: error))
                }
            }
        }
    }


}
