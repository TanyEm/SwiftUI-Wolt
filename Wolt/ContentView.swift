import SwiftUI
//
//let posters = [
//    "https://image.tmdb.org/t/p/original//pThyQovXQrw2m0s9x82twj48Jq4.jpg",
//    "https://image.tmdb.org/t/p/original//vqzNJRH4YyquRiWxCCOH0aXggHI.jpg",
//    "https://image.tmdb.org/t/p/original//6ApDtO7xaWAfPqfi2IARXIzj8QS.jpg",
//    "https://image.tmdb.org/t/p/original//7GsM4mtM0worCtIVeiQt28HieeN.jpg"
//].map { URL(string: $0)! }
//
//struct ContentView: View {
//    var body: some View {
//         List(posters, id: \.self) { url in
//             AsyncImage(
//                url: url,
//                placeholder: { Text("Loading ...") },
//                image: { Image(uiImage: $0).resizable() }
//             )
//            .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3) // 2:3 aspect ratio
//         }
//    }
//    
////    var body: some View {
////        VStack {
////            HStack {
////                AsyncImage(
////                    url: URL("https://image.tmdb.org/t/p/original//pThyQovXQrw2m0s9x82twj48Jq4.jpg"),
////                    placeholder: { Text("Loading ...") },
////                    image: { Image(uiImage: $0).resizable() }
////                )
////                .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3) // 2:3 aspect ratio
////            }
////        }
////    }
//}
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

struct V: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }
    
    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image

    var body: some View {
        selectImage()
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70, alignment: .center) // frame
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 5, x: 2, y: 2)
            .padding(4)
    }
    
    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
            _loader = StateObject(wrappedValue: Loader(url: url))
            self.loading = loading
            self.failure = failure
        }

        private func selectImage() -> Image {
            switch loader.state {
            case .loading:
                return loading
            case .failure:
                return failure
            default:
                if let image = UIImage(data: loader.data) {
                    return Image(uiImage: image)
                } else {
                    return failure
                }
            }
        }
}
