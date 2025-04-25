//
//  DataTaskExecuted.swift
//  Movies-Task
//
//  Created by Mostafa on 25/04/2025.
//


import Foundation
import Alamofire

extension DataTask {
    func executed<T: Codable>(type: T.Type) async throws -> T {
        do {
            let response = await self.result
            
            switch response {
            case let .success(data):
                return data as! T
            case let .failure(error):
                print(error.localizedDescription)
                throw ErrorMessage(error: error)
            }
        } catch {
            throw ErrorMessage(error: error)
        }
    }
}
