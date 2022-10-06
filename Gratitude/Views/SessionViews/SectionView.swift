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
    
    @State var isPresentingCaptionEditor = false
    @State var currentCaptionIndex = 0
    @State var captionString = ""
    
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
                                ForEach(Array(section.images.enumerated()), id: \.1) {
                                    (index,image) in
                                    VStack{
                                        GeometryReader{ innergeo in
                                            ZStack{
                                                if image.isLocal{
                                                    if let image = viewModel.getSavedImage(named: image.link) {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(height: 160)
                                                            .contentShape(Rectangle())
                                                            .cornerRadius(12)
                                                            .clipped()
                                                    }
                                                }
                                                else{
                                                    if let resource = viewModel.getImageResource(image.link) {
                                                        KFImage(source: Source.network(resource))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(height: 160)
                                                            .contentShape(Rectangle())
                                                            .cornerRadius(12)
                                                            .clipped()
                                                    }
                                                }
                                            }
                                            .clipped()
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
                                        .frame(height: 170)
                                        
                                        HStack{
                                            if image.caption.isEmpty{
                                                Text("Add a caption")
                                                    .font(Font.custom("Inter-Regular", size: 14))
                                                    .foregroundColor(Color("SectionSecondaryAccent"))
                                                    .zIndex(.greatestFiniteMagnitude)
                                                    .onTapGesture(count: 1) {
                                                        self.isPresentingCaptionEditor = true
                                                        self.currentCaptionIndex = index
                                                    }
                                            }else{
                                                HStack{
                                                    Text(image.caption)
                                                        .font(Font.custom("Inter-Regular", size: 14))
                                                    Spacer(minLength: 0)
                                                    Button {
                                                        self.isPresentingCaptionEditor = true
                                                        self.currentCaptionIndex = index
                                                    } label: {
                                                        Image("Pencil")
                                                            .resizable()
                                                            .aspectRatio(1, contentMode: .fit)
                                                            .frame(width: 14, height: 14, alignment: .center)
                                                    }
                                                }
                                            }
                                        }
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
                            presentationMode.wrappedValue.dismiss()
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
        .bottomSheet(showSheet: $isPresentingCaptionEditor) {
            SheetView(captionString: $captionString) {
                captionString = section.images[currentCaptionIndex].caption
            } doneAction: {
                let realm = stateManager.realm
                try? realm.write({
                    guard let image = section.images[currentCaptionIndex].thaw() else {
                       return
                    }
                    image.caption = captionString
                })
                captionString = ""
            }

        }
    }
    
    struct SheetView : View{
        @Environment(\.presentationMode) var presentationMode
        @Binding var captionString : String
        let onAppear: ()->Void
        let doneAction: ()->Void
        var body: some View {
            VStack(spacing: 20){
                HStack{
                    Text("""
                         Every photo has an origin 🌄
                         """)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                    .font(Font.custom("Inter-Bold", size: 20))
                    Spacer(minLength: 0)
                }
                ZStack{
                    if captionString.isEmpty{
                        Text("Write your story..")
                            .font(Font.custom("Inter-Regular", size: 14))
                            .foregroundColor(Color("SectionSecondaryAccent"))
                    }
                    TextEditor(text: $captionString)
                        .background {
                            Color.secondary.opacity(0.2)
                        }
                        .cornerRadius(10)
                }
                Button {
                    doneAction()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }
                .buttonStyle(NavigationButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
                onAppear()
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
