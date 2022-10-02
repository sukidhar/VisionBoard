//
//  ImageSearchView.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI

struct ImageSearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewModel = ViewModel()
    
    var backButton : some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(.gray)
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack{
                    Text("Powered by Pexels™")
                        .font(Font.custom("Inter-Medium", size: 14))
                        .foregroundColor(.secondary)
                        .padding(.leading, 35)
                    Spacer()
                }
                .padding(.top, 6)
                HStack{
                    Spacer()
                    Text("1 Photo Selected")
                        .font(Font.custom("Inter-Light", size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 4)
                .padding(.bottom, 6)
                ScrollView{
                    LazyVGrid(columns: [.init(),.init()]) {
                       
                    }
                }
                .scrollIndicators(.never)
            }.padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                HStack{
                    TextField(text: $viewModel.searchText, prompt: Text("Type to Enter")) {}
                        .font(Font.custom("Inter-Regular", size: 14))
                    Image("search")
                }
                .padding(9)
                .background {
                    Color("SearchFieldBG")
                }
                .cornerRadius(4)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image("Camera")
                        .padding(9)
                        .background {
                            Color("SearchFieldBG")
                        }
                        .cornerRadius(4)
                        .padding(.leading, -9)
                }
            }
        }
    }
    
    class ViewModel : ObservableObject{
        @Published var searchText = ""
        @Published var searchResultImages = [String]()
        
    }
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImageSearchView()
        }
    }
}
