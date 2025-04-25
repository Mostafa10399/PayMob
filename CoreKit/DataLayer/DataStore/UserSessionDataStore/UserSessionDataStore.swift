//
//  UserSessionDataStore.swift
//  CoreKit
//
//  Created by Mostafa on 25/04/2025.
//

import Foundation

public typealias UserSession = String

public protocol UserSessionDataStore {
    func getSession() async -> UserSession?
}
