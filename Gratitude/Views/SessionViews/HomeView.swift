//
//  HomeView.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

struct HomeView: View {
    let title : String
    var body: some View {
        NavigationView{
            GeometryReader{ _ in
                VStack{
                    HStack{
                        Button {
                            
                        } label: {
                            Text("+ ADD ANOTHER SECTION")
                                .foregroundColor(Color("PrimaryColor"))
                                .font(Font.custom("Inter-Regular", size: 12))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color("HomeAddButtonBG")))
                        }
                        .padding(.bottom, 30)
                        Spacer()
                    }
                    
                    ScrollView{
                        LazyVStack{
                            
                        }
                    }
            
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(title)
                        .font(Font.custom("Inter-Bold", size: 20))
                        .padding(8)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(title: "Sukidhar's HomeView")
    }
}
