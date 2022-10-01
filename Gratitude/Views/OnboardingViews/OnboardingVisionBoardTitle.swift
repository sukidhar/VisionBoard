//
//  InputVBTitle.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

struct OnboardingVisionBoardTitle: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel : OnboardingView.ViewModel
    @EnvironmentObject var stateManager : StateManager
    
    let bgQueue = DispatchQueue(label: "com.sukidhar.bgqueue")
    
    var backButton : some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(.gray)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("""
                 Hello \(viewModel.name)!😊👋🏽.
                 Let's give your vision board a name.
                 """)
            .multilineTextAlignment(.leading)
            .lineSpacing(5)
            .font(Font.custom("Inter-Bold", size: 20))
            Text("You can always change this later")
                .multilineTextAlignment(.leading)
                .font(Font.custom("Inter-Regular", size: 14))
                .foregroundColor(.secondary)
            TextField(text: $viewModel.boardTitle, prompt: Text("Type to Enter")) {}
                .keyboardType(.alphabet)
                .autocorrectionDisabled()
                .foregroundColor(Color("PrimaryColor"))
                .font(Font.custom("Inter-Bold", size: 20))
                .padding(.vertical)
            Text("or pick one from below")
                .multilineTextAlignment(.leading)
                .font(Font.custom("Inter-Regular", size: 14))
                .foregroundColor(.secondary)
                .padding(.vertical)
            FlowLayout(spacing: .init(width: 12, height: 12), items: generateSuggestedTitles()) { title in
                Button {
                    viewModel.boardTitle = title.text
                } label: {
                    Text(title.text)
                        .foregroundColor(.primary)
                        .font(Font.custom("Inter-Regular", size: 12))
                        .padding()
                        .background(Capsule().fill(Color("VBSTColor")))
                }

            }
            .frame(maxWidth: .infinity)
            Spacer()
            NavigationLink {
                AddSection(sectionUsage: .onboarding)
            } label: {
                Text("CONTINUE")
            }
            .buttonStyle(NavigationButtonStyle())
            .opacity(viewModel.boardTitle.isEmpty ? 0.4 : 1)
            .disabled(viewModel.boardTitle.isEmpty)
            .animation(.easeInOut, value: viewModel.boardTitle.isEmpty)
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
            .onDisappear {
                viewModel.saveUser()
            }
    }
    
    func generateSuggestedTitles() -> [IdentifiableString]{
        ["🕺 My Dream Life", "🎯 Vision Board \(Calendar.current.component(.year, from: Date()))", "💫 \(viewModel.name)'s Dream World"].map { string in
            IdentifiableString(text: string)
        }
    }
}

struct InputVBTitle_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OnboardingVisionBoardTitle()
                .environmentObject(OnboardingView.ViewModel())
        }
    }
}
