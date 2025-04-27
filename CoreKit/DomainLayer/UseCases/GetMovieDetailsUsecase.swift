//
//  GetMovieDetailsUsecase.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//

protocol GetMovieDetailsUsecase {
    var repository: MovieDetailsRepository { get }
    func getMovieDetails(with movieId: Int) async throws -> MovieDetailsPresentable
}

extension GetMovieDetailsUsecase {
    func getMovieDetails(with movieId: Int) async throws -> MovieDetailsPresentable {
        let movieDetails = try await repository.getMovieDetails(withId: movieId)
        return MovieDetailsPresentable(movieDetails)
    }
}
