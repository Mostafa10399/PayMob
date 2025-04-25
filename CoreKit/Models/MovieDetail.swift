//
//  MovieDetail.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

public enum MovieDetail: Hashable {
    public static func == (lhs: MovieDetail, rhs: MovieDetail) -> Bool {
        return lhs.index == rhs.index
    }
    
    case movie(MovieDetailsPresentable)
    case similar([MovieListPresentable])
    
    public var index: Int {
        switch self {
        case .movie: return 0
        case .similar: return 1
        }
    }
    
    public var title: String {
        switch self {
        case .movie: return ""
        case .similar: return "Similar movies"
        }
    }
}
