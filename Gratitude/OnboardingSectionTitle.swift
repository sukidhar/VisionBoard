//
//  OnboardingSectionTitle.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

struct OnboardingSectionTitle: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @State var isKeyboardPresented = false
    let name : String = "Suki"
    
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
                 Nice 😎
                 Let's add a section to begin.
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
            ScrollView(.horizontal){
                FlowLayout(spacing: .init(width: 12, height: 12), items: generateSuggestedTitles()) { title in
                    Button {
                        boardTitle = title.text
                    } label: {
                        Text(title.text)
                            .foregroundColor(.secondary)
                            .font(Font.custom("Inter-Regular", size: 12))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .stroke(Color.secondary.opacity(0.5))
                            )
                            .padding(.horizontal, 1)
                    }
                }
                .frame(width: 450, height: 50)
            }
            .scrollIndicators(.never)
            .frame(maxWidth: .infinity, maxHeight: 50)
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
        ["Travel", "Work", "Realtionships", "Health", "Finance"].map { string in
            IdentifiableString(text: string)
        }
    }
}

struct OnboardingSectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            OnboardingSectionTitle()
        }
    }
}
