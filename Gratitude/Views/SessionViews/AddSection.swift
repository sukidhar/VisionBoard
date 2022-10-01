//
//  OnboardingSectionTitle.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import RealmSwift

enum SectionUsageMode {
    case onboarding
    case home
}

struct AddSection: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel : OnboardingView.ViewModel
    @EnvironmentObject var stateManager: StateManager
    
    @State var sectionTitle : String = ""
    
    let sectionUsage : SectionUsageMode
    
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
            TextField(text: $sectionTitle, prompt: Text("Type to Enter")) {}
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
                        sectionTitle = title.text
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
            Button {
                let section = Section()
                section.title = sectionTitle
                guard let user = stateManager.realm.objects(User.self).first else{
                    return
                }
                try? stateManager.realm.write({
                    user.sections.append(section)
                })
                switch sectionUsage {
                case .onboarding:
                    stateManager.set(state: .homeView(user: user))
                case .home:
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("CONTINUE")
            }
            .buttonStyle(NavigationButtonStyle())
            .opacity(sectionTitle.isEmpty ? 0.4 : 1)
            .disabled(sectionTitle.isEmpty)
            .animation(.easeInOut, value: sectionTitle.isEmpty)
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.top, 24)
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
            AddSection(sectionUsage: .onboarding)
                .environmentObject(OnboardingView.ViewModel())
        }
    }
}
