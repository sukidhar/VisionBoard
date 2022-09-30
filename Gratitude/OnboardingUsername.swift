//
//  InputNameView.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import Combine


struct OnboardingUsername: View {
    @State var isKeyboardPresented = false
    @State var name : String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Spacer()
            Text("""
                 Alright.
                 What do we call you?
                 """)
            .multilineTextAlignment(.leading)
            .lineSpacing(5)
            .font(Font.custom("Inter-Bold", size: 20))
            Text("You can enter your first name here")
                .multilineTextAlignment(.leading)
                .font(Font.custom("Inter-Regular", size: 14))
                .foregroundColor(.secondary)
            TextField(text: $name, prompt: Text("Type to Enter")) {}
                .keyboardType(.alphabet)
                .autocorrectionDisabled()
                .foregroundColor(Color("PrimaryColor"))
                .font(Font.custom("Inter-Bold", size: 20))
                .padding(.vertical)
            Spacer()
            Button {
                
            } label: {
                Text("CONTINUE")
                    .font(Font.custom("Inter-Bold", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background {
                        Color("PrimaryColor")
                    }
                    .cornerRadius(8)
                    .padding(.bottom, isKeyboardPresented ? 24 : 0)
                    .opacity(name.isEmpty ? 0.4 : 1)
                    .disabled(name.isEmpty)
                    .animation(.easeInOut, value: isKeyboardPresented)
                    .animation(.easeInOut, value: name.isEmpty)
            }
        }.frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .onReceive(keyboardPublisher) { bool in
            isKeyboardPresented = bool
        }
    }
}

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingUsername()
    }
}
