//
//  Movie.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

public struct Movie: Codable {
    let id: Int
    let overview, title: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let originalLanguage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case originalLanguage = "original_language"
    }
}
