//
//  MovieAPI.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

public protocol MovieAPI: RemoteAPI {
    func getPopularMovies(
        auth: String,
        page: Int?,
        region: String?,
        language: String?
    ) async throws -> PaginationResponse<Movie>
    
    func getMovieDetails(
        auth: String,
        id: Int,
        language: String?
    ) async throws -> Movie
}

