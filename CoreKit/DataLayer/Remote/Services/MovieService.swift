//
//  MovieService.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation
import Alamofire

public enum MovieService {
    case popular(auth: String, page: Int? = nil, region: String? = nil, language: String? = nil)
    case movie(auth: String, id: Int, language: String? = nil)
}

extension MovieService: MoviesDBService {
    public var mainRoute: String { return "discover/" }

    public var requestConfiguration: RequestConfiguration {
        switch self {
        case let .popular(auth, page, region, language):
            var parameters: [String: Any] = ["api_key": auth]
            if let page = page {
                parameters["page"] = page
            }
            if let region = region {
                parameters["region"] = region
            }
            if let language = language {
                parameters["language"] = language
            }
            parameters["primary_release_year"] = 2024
            return RequestConfiguration(
                method: .get,
                path: mainRoute.appending("movie"),
                parameters: parameters,
                encoding: URLEncoding.queryString,
                language: language
            )
        case let .movie(auth, id, language):
            var parameters: [String: Any] = ["api_key": auth]
            if let language = language {
                parameters["language"] = language
            }
            return RequestConfiguration(
                method: .get,
                path: mainRoute.appending("\(id)"),
                parameters: parameters,
                encoding: URLEncoding.default,
                language: language
            )
        }
    }
}
