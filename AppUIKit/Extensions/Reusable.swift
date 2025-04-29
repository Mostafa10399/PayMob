//
//  Reusable.swift
//  PayMob-Task
//
//  Created by Mostafa on 30/04/2025.
//

import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension Reusable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: Bundle(for: self))
    }
}
