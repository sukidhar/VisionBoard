//
//  ImageSearchView.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import SwiftUI
import Combine
import Kingfisher


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
                .padding(.horizontal, 24)
                .padding(.top, 4)
                .padding(.bottom, 6)
                GeometryReader{ geometry in
                    ScrollView{
                        LazyVGrid(columns: [.init(.fixed(geometry.size.width/2), spacing: 1),.init(.fixed(geometry.size.width/2), spacing: 1)], spacing: 1) {
                            ForEach(Array(viewModel.searchResultImages.enumerated()), id: \.1.self) {
                                (index,link) in
                                if let resource = getImageResource(link) {
                                    ZStack{
                                        KFImage(source: .network(resource))
                                            .diskStoreWriteOptions(.completeFileProtection)
                                            .placeholder({ _ in
                                                Color.secondary.opacity(0.3).frame(height: geometry.size.width/2)
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
                                                    let vbImage = VBImage()
                                                    vbImage.link = link
                                                    vbImage.isLocal = false
                                                    viewModel.selectedImages.append(vbImage)
                                                }
                                            }
                                        if isSelected(link: link){
                                            Color.gray
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
                }
            }
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
                        .padding(.leading, 9)
                    Button {
                        viewModel.performSearchRequest()
                    } label: {
                        Image("search")
                    }
                }
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
        .onChange(of: viewModel.searchText) { newValue in
            viewModel.pageNumber = 1
            KingfisherManager.shared.cache.clearMemoryCache()
        }
        .onDisappear {
            KingfisherManager.shared.cache.clearMemoryCache()
        }
    }
    
    func isSelected(link: String)->Bool{
        return viewModel.selectedImages.contains { image in
            image.link == link
        }
    }
    
    func getImageResource(_ link: String) -> ImageResource?{
        guard let url = URL(string: link) else {
            return nil
        }
        return .init(downloadURL: url, cacheKey: link)
    }
    
    class ViewModel : ObservableObject{
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
                        print(photo.src.original)
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
            ImageSearchView()
        }
    }
}
