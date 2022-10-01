//
//  SectionView.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI
import RealmSwift

struct SectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton : some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(.gray)
        }
    }
    
    @ObservedRealmObject var section : Section
    
    var body: some View {
        VStack(spacing: 20){
            if section.images.isEmpty{
                Image("SectionEmpty")
                Text("Start manifesting your \(section.title)")
                    .font(Font.custom("Inter-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(3)
                NavigationLink {
                    ImageSearchView()
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
            }else{
                LazyVStack(spacing: 20){
                    
                }
            }
        }.padding(.horizontal, 24)
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
    
    @discardableResult
    func saveImage(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        do {
            let path = directory.appendingPathComponent("\(ObjectId.generate()).png")!
            try data.write(to: path)
            return path.absoluteString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
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
