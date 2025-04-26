//
//  GetMoviesUsecase.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//

protocol GetMoviesUsecase {
    var repository: MovieRepository { get }
    nonisolated func getMovies(page: Int) async throws -> [MovieListPresentable]
}

extension GetMoviesUsecase {
    nonisolated func getMovies(page: Int) async throws -> [MovieListPresentable] {
        let movies = try await repository.getPopularMovies(page: page)
        let presentables = movies.compactMap(MovieListPresentable.init)
        return presentables
    }
}
