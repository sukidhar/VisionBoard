//
//  SectionView.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI
import RealmSwift
import Kingfisher

struct SectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var stateManager : StateManager
    
    var backButton : some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(.gray)
        }
    }
    @StateObject var viewModel = ViewModel()
    
    @ObservedRealmObject var section : Section
    
    var body: some View {
        ZStack{
            if section.images.isEmpty{
                VStack{
                    Image("SectionEmpty")
                    Text("Start manifesting your \(section.title)")
                        .font(Font.custom("Inter-Bold", size: 20))
                        .multilineTextAlignment(.center)
                        .padding(3)
                    NavigationLink {
                        ImageSearchView(section: section)
                    } label: {
                        Text(Image(systemName: "camera")) + Text("ADD PHOTOS")
                    }.font(Font.custom("Inter-Bold", size: 14))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 19)
                        .background {
                            Color("PrimaryColor")
                        }
                        .cornerRadius(8)
                }
                .padding(24)
            }else{
                VStack{
                    GeometryReader{ geometry in
                        ScrollView{
                            LazyVStack(spacing: 20){
                                ForEach(section.images) {
                                    image in
                                    VStack{
                                        GeometryReader{ innergeo in
                                            ZStack{
                                                if image.isLocal{
                                                    if let image = viewModel.getSavedImage(named: image.link) {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(height: 150)
                                                            .cornerRadius(12)
                                                    }
                                                }
                                                else{
                                                    if let resource = viewModel.getImageResource(image.link) {
                                                        KFImage(source: Source.network(resource))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(height: 160)
                                                            .cornerRadius(12)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 5)
                                            .overlay {
                                                Button {
                                                    let realm = stateManager.realm
                                                    if let index = section.images.map({ $0 }).enumerated().first(where: { (index,sImage) in
                                                        sImage.id == image.id
                                                    })?.offset{
                                                        try? realm.write({
                                                            $section.images.remove(at: index)
                                                        })
                                                        try? realm.commitWrite()
                                                    }
                                                } label: {
                                                    ZStack{
                                                        Color("SectionImageDeleteBG")
                                                        Text("-")
                                                            .font(Font.custom("Inter-Bold", size: 20))
                                                            .offset(y: -1)
                                                            .foregroundColor(Color(.systemBackground))
                                                    }
                                                }
                                                .frame(width: 20, height: 20)
                                                .cornerRadius(10)
                                                .position(.init(x: innergeo.frame(in: .local).width - 26, y: innergeo.frame(in: .local).minX + 7))
                                            }
                                        }
                                        .frame(height: 160)
                                        
                                        Text("Add a caption")
                                            .font(Font.custom("Inter-Regular", size: 14))
                                            .foregroundColor(Color("SectionSecondaryAccent"))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 6)
                                    }
                                }
                            }
                        }
                    }
                    HStack(spacing: 10){
                        NavigationLink {
                            ImageSearchView(section: section)
                        } label: {
                            Text(Image(systemName: "camera")) + Text(" ADD PHOTO")
                        }
                        .font(Font.custom("Inter-Bold", size: 14))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background {
                            Color("SectionAddButtonBG")
                        }
                        .cornerRadius(8)
                        Button {
                            
                        } label: {
                            Text("DONE ") + Text(Image(systemName: "checkmark"))
                        }
                        .buttonStyle(NavigationButtonStyle())
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Text(section.title)
                    .font(Font.custom("Inter-Bold", size: 20))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    class ViewModel: ImageHelper, ObservableObject{
        
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        let section = Section()
        section.title = "Section Title"
        section.images = .init()
        return SectionView(section: section)
    }
}
