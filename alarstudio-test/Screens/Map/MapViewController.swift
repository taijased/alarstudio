//
//  MapViewController.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 10.12.2020.
//


import SwiftUI
import UIKit
import Combine
import MapKit

class MapViewController: UIHostingController<MapView> {
    
    private let viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(rootView: MapView(viewModel: viewModel))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {

            Map(coordinateRegion: $viewModel.coordinateRegion)
                   .edgesIgnoringSafeArea(.all)
            infoBlock
            
        }
        
    }
    
    
    
    private var closeButton: some View {
        
        Button(action: {
            self.viewModel.close()
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        }
        .frame(minWidth: 100, maxWidth: 100, minHeight: 44, maxHeight: 44, alignment: .center)
        .position(x: UIScreen.main.bounds.width - 55, y: 40)
    }
    
    
    private var infoBlock: some View {
       
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.black)
            VStack(alignment: .leading) {
                Spacer()
                Text(viewModel.country.country)
                    .colorInvert()
                    .font(.headline)
                Spacer()
                Text(viewModel.country.name)
                    .colorInvert()
                    .font(.caption)
                Spacer()
                Text(viewModel.country.id)
                    .colorInvert()
                    .font(.caption2)
                Spacer()
                HStack {
                    Text(String(viewModel.country.lat))
                        .colorInvert()
                        .font(.caption2)
                    Spacer()
                    Text(String(viewModel.country.lon))
                        .colorInvert()
                        .font(.caption2)
                }
                Spacer()
                
            }.padding()
            closeButton
                
        }.frame(width: UIScreen.main.bounds.width - 30, height: 150)
        
    }
}

extension MapView {
    struct TextFieldAppearance: ViewModifier {
        
        func body(content: Content) -> some View {
            content
                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.separator), lineWidth: 1))
        }
    }
}



#if DEBUG
// MARK: - Preview

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: .init(container: TempraryCountriesContainer(), country: Country.example))
    }
}

#endif
