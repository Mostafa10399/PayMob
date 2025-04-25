//
//  UIViewController+Alert.swift
//  PayMob-Task
//
//  Created by Mostafa on 25/04/2025.
//


import UIKit
import CoreKit
import Combine

public extension UIViewController {
    
    // MARK: - Methods
    func present(errorMessage: ErrorMessage) {
        let errorAlertController = UIAlertController(title: errorMessage.title,
                                                     message: errorMessage.message,
                                                     preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }
    
    func present(errorMessage: ErrorMessage,
                 withPresentationState errorPresentation: CurrentValueSubject<ErrorPresentation?, Never>? = nil) {
        errorPresentation?.send(.presenting)
        let errorAlertController = UIAlertController(title: errorMessage.title,
                                                     message: errorMessage.message,
                                                     preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            errorPresentation?.send(.dismissed)
            errorPresentation?.send(nil)
        }
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }
}
