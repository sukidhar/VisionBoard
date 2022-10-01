//
//  OnboardingView.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI
import RealmSwift

struct OnboardingView: View {
    
    @StateObject var viewModel : ViewModel = .init()
    
    var body: some View {
        ZStack{
            switch viewModel.state {
            case .opening:
                OnboardingOpeningView {
                    viewModel.goToDetailViews()
                }
            case .details:
                OnboardingUsername()
                    .environmentObject(viewModel)
            }
        }
        .animation(.easeIn, value: viewModel.state == .opening)
    }
    
    class ViewModel : ObservableObject{
        @Published var state : OnboardingState = .opening
        @Published var name : String = ""
        @Published var boardTitle : String = ""
        @Published var sectionTitle : String = ""
        
        func goToDetailViews(){
            state = .details
        }
        
        func generateUser()->User{
            let user = User()
            user.name = name
            user.visionBoardTitle = boardTitle
            user.sections = .init()
            let section = Section()
            section.title = sectionTitle
            user.sections.append(section)
            return user
        }
    }
    
    enum OnboardingState {
        case opening
        case details
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
