//
//  HomeView.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @ObservedRealmObject var user : User
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
                                        }.frame(maxWidth: .infinity, idealHeight: 130, maxHeight: 130)
                                            .cornerRadius(9.5)
                                    }else{
                                        HStack{
                                            Text("f")
                                        }.frame(maxWidth: .infinity, idealHeight: 130, maxHeight: 130)
                                            .background {
                                                Color.blue
                                            }
                                            .cornerRadius(9.5)
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
