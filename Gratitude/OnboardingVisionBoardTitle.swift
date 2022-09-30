//
//  InputVBTitle.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

struct OnboardingVisionBoardTitle: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @State var isKeyboardPresented = false
    let name : String
    
    @State var boardTitle : String = ""
    
    
    var backButton : some View {
        Button {
            
        } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(.gray)
        }
    }
    
    var continueButton : some View {
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
                .opacity(boardTitle.isEmpty ? 0.4 : 1)
                .disabled(boardTitle.isEmpty)
                .animation(.easeInOut, value: isKeyboardPresented)
                .animation(.easeInOut, value: boardTitle.isEmpty)
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("""
                 Hello \(name)!😊👋🏽.
                 Let's give your vision board a name.
                 """)
            .multilineTextAlignment(.leading)
            .lineSpacing(5)
            .font(Font.custom("Inter-Bold", size: 20))
            Text("You can always change this later")
                .multilineTextAlignment(.leading)
                .font(Font.custom("Inter-Regular", size: 14))
                .foregroundColor(.secondary)
            TextField(text: $boardTitle, prompt: Text("Type to Enter")) {}
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
                    boardTitle = title.text
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
            continueButton
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .onReceive(keyboardPublisher) { bool in
                isKeyboardPresented = bool
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
    }
    
    func generateSuggestedTitles() -> [IdentifiableString]{
        ["🕺 My Dream Life", "🎯 Vision Board \(Calendar.current.component(.year, from: Date()))", "💫 \(name)'s Dream World"].map { string in
            IdentifiableString(text: string)
        }
    }
}

struct InputVBTitle_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OnboardingVisionBoardTitle(name: "Sukidhar")
        }
    }
}
