//
//  DefaultMovieDetailsRepositoryImpelementation.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

final public class DefaultMovieDetailsRepositoryImpelementation: MovieDetailsRepository {
    
    // MARK: - Properties
    
    private let remoteAPI: MovieAPI
    private let userSessionDataStore: UserSessionDataStore
    private let watchlistDataStore: WatchlistDataStore
    
    // MARK: - Methods
    
    public init(
        remoteAPI: MovieAPI,
        userSessionDataStore: UserSessionDataStore,
        watchlistDataStore: WatchlistDataStore
    ) {
        self.remoteAPI = remoteAPI
        self.userSessionDataStore = userSessionDataStore
        self.watchlistDataStore = watchlistDataStore
    }
    
    public func getMovieDetails(withId id: Int) async throws -> MovieWithWatchlist {
        guard let session = await userSessionDataStore.getSession() else {
            throw ErrorMessage(
                error: NSError(
                    domain: "SessionError",
                    code: 401,
                    userInfo: [NSLocalizedDescriptionKey: "No user session found"]
                )
            )
        }
        let movie = try await remoteAPI.getMovieDetails(auth: session, id: id, language: nil)
        let isInWatchlist = try await watchlistDataStore.isMovieInWatchlist(id: movie.id)
        return MovieWithWatchlist(movie: movie, isInWatchlist: isInWatchlist)
    }
    
    public func toggleWatchlist(for id: Int) async throws -> Bool {
        let isInWatchlist = try await watchlistDataStore.isMovieInWatchlist(id: id)
        if isInWatchlist {
            try await watchlistDataStore.removeFromWatchlist(id: id)
        } else {
            try await watchlistDataStore.addToWatchlist(id: id)
        }
        return try await watchlistDataStore.isMovieInWatchlist(id: id)
    }
}
