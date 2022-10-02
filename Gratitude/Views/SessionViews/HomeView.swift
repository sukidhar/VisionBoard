//
//  HomeView.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import RealmSwift
import Kingfisher

struct HomeView: View {
    
    @ObservedRealmObject var user : User
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView{
            GeometryReader{ _ in
                VStack{
                    HStack{
                        NavigationLink {
                            AddSection(sectionUsage: .home)
                        } label: {
                            Text("+ ADD ANOTHER SECTION")
                                .foregroundColor(Color("PrimaryColor"))
                                .font(Font.custom("Inter-Regular", size: 12))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color("HomeAddButtonBG")))
                        }
                        .padding(.bottom, 30)
                        .padding(.horizontal, 24)
                        Spacer()
                    }
                    ScrollView{
                        LazyVStack(spacing: 20){
                            ForEach(user.sections, id: \.id) {
                                section in
                                VStack{
                                    HStack{
                                        Text(section.title)
                                        Spacer()
                                        NavigationLink {
                                            SectionView(section: section)
                                                .onAppear{
                                                    print(section)
                                                }
                                        } label: {
                                            Image("Pencil")
                                        }
                                    }
                                    if section.images.isEmpty{
                                        GeometryReader{
                                            geomtry in
                                            HStack(spacing: 3.8){
                                                VStack{
                                                    Color("JournalBG")
                                                }.frame(width: geomtry.size.width * 0.37)
                                                Color("JournalBG2")
                                                VStack(spacing: 3.8){
                                                    Color("JournalBG3")
                                                    Color("JournalBG4")
                                                }
                                            }
                                        }
                                        .frame(height: 130)
                                        .cornerRadius(9.5)
                                    }else{
                                        if section.images.count == 1{
                                            HStack(spacing: 4){
                                                Color("JournalBG")
                                                    .overlay {
                                                        VBImageViewer(image: section.images[0])
                                                    }
                                                    .clipped()
                                            }
                                            .frame(height: 130)
                                            .frame(maxWidth: .infinity)
                                            .cornerRadius(9.5)
                                            .zIndex(-.infinity)
                                        }
                                        else if section.images.count == 2 {
                                            HStack(spacing: 4){
                                                Color("JournalBG")
                                                    .overlay {
                                                        VBImageViewer(image: section.images[0])
                                                    }
                                                    .clipped()
                                                Color("JournalBG2")
                                                    .overlay {
                                                        VBImageViewer(image: section.images[1])
                                                    }
                                                    .clipped()
                                            }
                                            .frame(height: 130)
                                            .frame(maxWidth: .infinity)
                                            .cornerRadius(9.5)
                                            .zIndex(-.infinity)
                                        }
                                        else if section.images.count == 3{
                                            HStack(spacing: 4){
                                                Color("JournalBG")
                                                    .overlay {
                                                        VBImageViewer(image: section.images[0])
                                                    }
                                                    .clipped()
                                                VStack(spacing: 4){
                                                    Color("JournalBG")
                                                        .overlay {
                                                            VBImageViewer(image: section.images[1])
                                                        }
                                                        .clipped()
                                                    Color("JournalBG")
                                                        .overlay {
                                                            VBImageViewer(image: section.images[2])
                                                        }
                                                        .clipped()
                                                }
                                            }
                                            .frame(height: 130)
                                            .frame(maxWidth: .infinity)
                                            .cornerRadius(9.5)
                                            .zIndex(-.infinity)
                                        }else if section.images.count == 4{
                                            GeometryReader{
                                                geo in
                                                HStack(spacing: 3.8){
                                                    VStack{
                                                        Color("JournalBG")
                                                            .overlay {
                                                                VBImageViewer(image: section.images[0])
                                                            }
                                                    }.frame(width: geo.size.width * 0.37)
                                                        .clipped()
                                                    Color("JournalBG2")
                                                        .overlay {
                                                            VBImageViewer(image: section.images[1])
                                                        }
                                                        .clipped()
                                                    VStack(spacing: 3.8){
                                                        Color("JournalBG3")
                                                            .overlay {
                                                                VBImageViewer(image: section.images[2])
                                                            }
                                                            .clipped()
                                                        Color("JournalBG4")
                                                            .overlay {
                                                                VBImageViewer(image: section.images[3])
                                                            }
                                                            .clipped()
                                                    }
                                                }
                                            }
                                            .frame(height: 130)
                                            .cornerRadius(9.5)
                                            .zIndex(-.infinity)
                                        }
                                        else{
                                            HStack(spacing: 4){
                                                VStack(spacing: 4){
                                                    Color("JournalBG")
                                                        .overlay {
                                                            VBImageViewer(image: section.images[0])
                                                        }
                                                        .clipped()
                                                    Color("JournalBG2")
                                                        .overlay {
                                                            VBImageViewer(image: section.images[1])
                                                        }
                                                        .clipped()
                                                }
                                                VStack(spacing: 4){
                                                    Color("JournalBG3")
                                                        .overlay {
                                                            VBImageViewer(image: section.images[2])
                                                        }
                                                        .clipped()
                                                    VStack(spacing: 4){
                                                        Color("JournalBG4")
                                                            .overlay {
                                                                VBImageViewer(image: section.images[3])
                                                            }
                                                            .clipped()
                                                        Color("JournalBG")
                                                            .overlay {
                                                                VBImageViewer(image: section.images[4])
                                                            }
                                                            .clipped()
                                                    }
                                                }
                                            }
                                            .frame(idealHeight: 260, maxHeight: 260)
                                            .cornerRadius(9.5)
                                            .clipped()
                                            .zIndex(-.infinity)
                                        }
                                    }
                                }
                            }
                        }.padding(.horizontal, 24)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(user.visionBoardTitle)
                        .font(Font.custom("Inter-Bold", size: 20))
                        .padding(8)
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }
    
    class ViewModel : ImageHelper,ObservableObject{
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let user : User = {
            let user = User()
            user.name = "Sukidhar"
            user.visionBoardTitle = "Sukidhar's Dream Board"
            user.sections = .init()
            Array(1...5).forEach { i in
                let section = Section()
                section.title = "Section \(i)"
                user.sections.append(section)
            }
            return user
        }()
        return HomeView(user: user)
    }
}

struct VBImageViewer : View{
    let image: VBImage
    let helper = ImageHelper()
    var body: some View {
        if image.isLocal{
            if let image = helper.getSavedImage(named: image.link) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            }
        }
        else{
            if let resource = helper.getImageResource(image.link) {
                KFImage(source: Source.network(resource))
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            }
        }
    }
}
