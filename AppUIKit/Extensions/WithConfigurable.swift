//
//  WithConfigurable.swift
//  PayMob-Task
//
//  Created by Mostafa on 25/04/2025.
//


import Foundation

public protocol WithConfigurable {}
public extension WithConfigurable where Self: AnyObject {
    @discardableResult
    func with(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: WithConfigurable {}
