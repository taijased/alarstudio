//
//  SwiftUI + ImageLoader.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 10.12.2020.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    private var size: CGSize
    init(withURL url:String, size: CGSize) {
        imageLoader = ImageLoader(urlString:url)
        self.size = size
    }

    var body: some View {

            Image(uiImage: image)
                .resizable()
//                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
    }
}
