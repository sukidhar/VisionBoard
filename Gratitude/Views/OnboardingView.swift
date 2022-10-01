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
        @Published var boardTitle : String = ""{
            didSet {
                if boardTitle.count > 30 && oldValue.count <= 30 {
                    boardTitle = oldValue
                }
            }
        }
        
        let user = User()
        
        func goToDetailViews(){
            state = .details
        }
        
        func saveUser(){
            user.name = name
            user.visionBoardTitle = boardTitle
            user.sections = .init()
            let realm = try! Realm(configuration: .init(deleteRealmIfMigrationNeeded: true))
            try? realm.write({
                realm.add(user)
            })
            try? realm.commitWrite()
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
