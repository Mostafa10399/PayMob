//
//  GetMovieDetailsUsecase.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//

protocol GetMovieDetailsUsecase {
    func getMovieDetails(with movieId: Int) async throws -> MovieDetailsPresentable
}
