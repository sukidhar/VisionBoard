//
//  NavigationButtonStyle.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI

struct NavigationButtonStyle: ButtonStyle {
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AnyButton(configuration: configuration)
    }
    
    struct AnyButton: View {
        @Environment(\.isEnabled) private var isEnabled: Bool
        @State var isKeyboardPresented = false
        
        let configuration: ButtonStyle.Configuration
        
        var body: some View {
            configuration.label
                .font(Font.custom("Inter-Bold", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background {
                    Color("PrimaryColor")
                }
                .cornerRadius(8)
                .padding(.bottom, isKeyboardPresented ? 24 : 0)
                .animation(.easeInOut, value: isKeyboardPresented)
                .disabled(!isEnabled)
                .onReceive(keyboardPublisher) { bool in
                    isKeyboardPresented = bool
                }
        }
    }
}
