//
//  InputNameView.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import Combine


struct OnboardingUsername: View {
    @EnvironmentObject var viewModel : OnboardingView.ViewModel
    
    var body: some View {
        NavigationView {
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
                TextField(text: $viewModel.name, prompt: Text("Type to Enter")) {}
                    .autocorrectionDisabled()
                    .foregroundColor(Color("PrimaryColor"))
                    .font(Font.custom("Inter-Bold", size: 20))
                    .padding(.vertical)
                Spacer()
                NavigationLink {
                    OnboardingVisionBoardTitle()
                } label: {
                    Text("CONTINUE")
                }
                .buttonStyle(NavigationButtonStyle())
                .opacity(viewModel.name.isEmpty ? 0.4 : 1)
                .animation(.easeInOut, value: viewModel.name.isEmpty)
                .disabled(viewModel.name.isEmpty)
            }.frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
        }
    }
}

struct InputNameView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingUsername()
            .environmentObject(OnboardingView.ViewModel())
    }
}
