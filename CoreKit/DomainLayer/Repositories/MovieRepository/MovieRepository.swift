//
//  MovieRepository.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

public protocol MovieRepository {
    func getPopularMovies(page: Int) async throws -> [MovieWithWatchlist]
}
