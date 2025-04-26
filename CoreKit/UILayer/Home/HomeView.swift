//
//  HomeView.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//

import Foundation

public enum HomeView {
    case root
    case details(id: Int, responder: ToggledWatchlistResponder)
}
