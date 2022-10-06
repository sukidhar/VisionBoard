//
//  View+Extension.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import Combine

extension View {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false })
            .eraseToAnyPublisher()
    }
}
