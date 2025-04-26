//
//  MDBMovieAPI.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

final public class MDBMovieAPI: MovieAPI {
    
    // MARK: - Properties
    
    // MARK: - Methods
    
    public init() { }
    
    public func getPopularMovies(
        auth: String,
        page: Int?,
        region: String?,
        language: String?
    ) async throws -> PaginationResponse<Movie> {
        try await request(
            MovieService.popular(
                auth: auth,
                page: page,
                region: region,
                language: language
            )
        )
    }
    
    public func getMovieDetails(
        auth: String,
        id: Int,
        language: String?
    ) async throws -> Movie {
        try await request(
            MovieService.movie(
                auth: auth,
                id: id,
                language: language
            )
        )
    }
}
