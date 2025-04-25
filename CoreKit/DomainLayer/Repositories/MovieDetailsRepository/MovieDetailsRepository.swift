//
//  MovieDetailsRepository.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

public protocol MovieDetailsRepository {
    func getMovieDetails(withId id: Int) async throws -> MovieWithWatchlist
    func toggleWatchlist(for id: Int) async throws -> Bool
}

