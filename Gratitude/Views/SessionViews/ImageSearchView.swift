//
//  ImageSearchView.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI
import Combine
import RealmSwift
import Kingfisher


struct ImageSearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = ViewModel()
    
    @State var isPresentingActionSheet = false
    @State var isPresentingCamera = false
    @State var isPresentingGallery = false
    @State var newImage : UIImage?
    @State var galleryImages: [UIImage] = []
    
    @ObservedRealmObject var section: Section
    @EnvironmentObject var stateManger : StateManager
    
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
            VStack(spacing: 0){
                HStack{
                    Text("Powered by Pexels™")
                        .font(Font.custom("Inter-Medium", size: 14))
                        .foregroundColor(.secondary)
                        .padding(.leading, 35)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 6)
                HStack{
                    Spacer()
                    if viewModel.selectedImages.count > 0 {
                        Text("\(viewModel.selectedImages.count) Photo Selected")
                            .font(Font.custom("Inter-Light", size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(height: 24)
                .padding(.horizontal, 24)
                .padding(.top, 4)
                .padding(.bottom, 6)
                GeometryReader{ scrollGeometry in
                    VStack(spacing: 0){
                        ScrollView{
                            LazyVGrid(columns: [.init(.fixed(scrollGeometry.size.width/2-0.5), spacing: 1),.init(.fixed(scrollGeometry.size.width/2-0.5), spacing: 1)], spacing: 1) {
                                ForEach(Array(viewModel.searchResultImages.enumerated()), id: \.1.self) {
                                    (index,link) in
                                    if let resource = viewModel.getImageResource(link) {
                                        ZStack{
                                            KFImage(source: .network(resource))
                                                .diskStoreWriteOptions(.completeFileProtection)
                                                .placeholder({ _ in
                                                    Color.secondary.opacity(0.3).frame(height: scrollGeometry.size.width/2)
                                                        .redacted(reason: .placeholder)
                                                        .shimmer()
                                                })
                                                .retry(maxCount: 5, interval: .seconds(5))
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fit)
                                                .onAppear {
                                                    if index == viewModel.searchResultImages.count - 1 {
                                                        print("can query")
                                                        if viewModel.pageNumber * 15 < viewModel.maxResults{
                                                            viewModel.pageNumber += 1
                                                            viewModel.performSearchRequest()
                                                        }
                                                    }
                                                }
                                                .onDisappear {
                                                    KingfisherManager.shared.cache.removeImage(forKey: link, fromDisk: false)
                                                }
                                                .onTapGesture {
                                                    if viewModel.selectedImages.count < 5{
                                                        viewModel.selectImage(link: link)
                                                    }
                                                }
                                            if isSelected(link: link){
                                                ZStack{
                                                    Color.black.opacity(0.2)
                                                    Image("Check")
                                                }
                                                .onTapGesture {
                                                    viewModel.selectedImages = viewModel.selectedImages.filter({ vbImage in
                                                        vbImage.link != link
                                                    })
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.never)
                        if viewModel.selectedImages.count > 0 {
                            GeometryReader{ hGeometry in
                                HStack(spacing: 0){
                                    ScrollView(.horizontal){
                                        LazyHStack(spacing: 1) {
                                            ForEach(viewModel.selectedImages) { image in
                                                Color.black
                                                    .frame(width: 56, height:56)
                                                    .overlay {
                                                        VBImageViewer(image: image)
                                                    }
                                                    .clipped()
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                    .scrollIndicators(.never)
                                    Spacer(minLength: 0)
                                    Button {
                                        let realm = stateManger.realm
                                            try? realm.write({
                                                $section.images.wrappedValue = .init()
                                            })
                                            viewModel.selectedImages.forEach { image in
                                                try? realm.write({
                                                    $section.images.append(image)
                                                })
                                            }
                                            try? realm.commitWrite()
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image("ArrowCircleRight")
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                }
                            }
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .background {
                                Color.black
                            }
                        }
                    }
                }
            }
        }
        .confirmationDialog("Choose a method", isPresented: $isPresentingActionSheet, actions: {
            Button {
                isPresentingCamera.toggle()
            } label: {
                Text("Camera")
            }
            Button {
                isPresentingGallery.toggle()
            } label: {
                Text("Gallery")
            }
            Button("Cancel", role: .cancel) {}
        })
        .fullScreenCover(isPresented: $isPresentingCamera, content: {
            ImagePickerView(capturedImage: $newImage)
                .edgesIgnoringSafeArea(.all)
        })
        .fullScreenCover(isPresented: $isPresentingGallery, content: {
            ImageGalleryView(images: $galleryImages, limit: 5 - viewModel.selectedImages.count)
                .edgesIgnoringSafeArea(.all)
        })
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                HStack{
                    TextField(text: $viewModel.searchText, prompt: Text("Type to Enter")) {}
                        .keyboardType(UIKeyboardType.webSearch)
                        .font(Font.custom("Inter-Regular", size: 14))
                        .padding(9)
                        .onSubmit {
                            viewModel.performSearchRequest()
                        }
                    Button {
                        viewModel.performSearchRequest()
                    } label: {
                        Image("search")
                    }
                }
                .background {
                    if colorScheme == .light{
                        Color("SearchFieldBG")
                    }else{
                        Color.white
                            .opacity(0.3)
                    }
                }
                .cornerRadius(4)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresentingActionSheet.toggle()
                } label: {
                    Image("Camera")
                        .padding(9)
                        .background {
                            if colorScheme == .light{
                                Color("SearchFieldBG")
                            }else{
                                if colorScheme == .light{
                                    Color("SearchFieldBG")
                                }else{
                                    Color.white
                                        .opacity(0.3)
                                }
                            }
                        }
                        .cornerRadius(4)
                        .padding(.leading, -9)
                }
            }
        }
        .onChange(of: viewModel.searchText) { newValue in
            viewModel.pageNumber = 1
            KingfisherManager.shared.cache.clearMemoryCache()
        }
        .onDisappear {
            KingfisherManager.shared.cache.clearMemoryCache()
        }
        .onChange(of: newImage) { _ in
            if let image = newImage, let link = viewModel.saveImage(image: image){
                viewModel.selectImage(link: link, isLocal: true)
            }
            self.newImage = nil
        }
        .onChange(of: galleryImages) { images in
            images.forEach { image in
                if let link = viewModel.saveImage(image: image){
                    viewModel.selectImage(link: link, isLocal: true)
                }
            }
            galleryImages = []
        }
        .onAppear {
            viewModel.selectedImages = section.images.map { $0 }
        }
    }
    
    func isSelected(link: String)->Bool{
        return viewModel.selectedImages.contains { image in
            image.link == link
        }
    }
    
    class ViewModel : ImageHelper, ObservableObject{
        @Published var searchText = ""
        @Published var searchResultImages = [String]()
        @Published var pageNumber = 1
        @Published var selectedImages = [VBImage]()
        
        var maxResults = 0
        var sink : AnyCancellable?
        
        var urlString : String {
            return "https://api.pexels.com/v1/search?query=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "_")&page=\(pageNumber)"
        }
        
        
        func fetchAPIKey() -> String?{
            guard let apiKey = Bundle.main.infoDictionary?["PEXELS_API_KEY"] as? String else{
                return nil
            }
            return apiKey
        }
        
        func buildRequest() -> URLRequest?{
            guard let apiKey = fetchAPIKey(), let url = URL(string: urlString) else {
                return nil
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue(apiKey, forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "get"
            return urlRequest
        }
        
        func selectImage(link: String, isLocal: Bool = false){
            let vbImage = VBImage()
            vbImage.link = link
            vbImage.isLocal = isLocal
            selectedImages.append(vbImage)
        }
        
        func performSearchRequest(){
            if searchText.isEmpty{
                return
            }
            sink = fetchResults()
                .sink { result in
                    switch result{
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                } receiveValue: { [unowned self] strings in
                    if pageNumber == 1{
                        searchResultImages = strings.map({ "\($0)?auto=compress"
                        })
                    }else{
                        searchResultImages.append(contentsOf: strings.map({ "\($0)?auto=compress"
                        }))
                    }
                }
        }
        
        private func fetchResults() -> AnyPublisher<[String],Error> {
            guard let request = buildRequest() else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data,response in
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: PexelQueryResult.self, decoder: JSONDecoder())
                .map {[weak self] result in
                    self?.maxResults = result.totalResults
                    return result.photos.map { photo in
                        return photo.src.original
                    }
                }
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
    
    struct LoadedImage {
        let link: String
        let isLocal: Bool
    }
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImageSearchView(section: .init())
                .environmentObject(StateManager())
                .preferredColorScheme(.dark)
        }
    }
}
