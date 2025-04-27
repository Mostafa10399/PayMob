//
//  Array+Safe.swift
//  PayMob-Task
//
//  Created by Mostafa on 25/04/2025.
//


import Foundation

// MARK: - Safe Array Indexing Extension
public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}