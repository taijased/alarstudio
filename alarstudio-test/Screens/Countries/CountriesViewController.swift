//
//  CountriesViewController.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 08.12.2020.
//


import SwiftUI
import UIKit
import Combine

class CountriesViewController: UIHostingController<CountriesView> {
    
    private let viewModel: CountriesViewModel
    
    init(viewModel: CountriesViewModel) {
        self.viewModel = viewModel
        super.init(rootView:  CountriesView(viewModel: viewModel))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct CountriesView: View {
    
    @ObservedObject var viewModel: CountriesViewModel
    
    var body: some View {
        
        NavigationView {
            List(viewModel.countries) { country in
                CountryCell(country: country)
                    .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    viewModel.select(country: country)
                                }
                    )
                    .onAppear {
                        
                        viewModel.loadNextPage(country)
                    }
            }
            
            .navigationBarTitle("Countries")
            .navigationBarItems(trailing:
                Button("Logout") {
                    viewModel.logOut()
                }
            )
        }.onAppear(perform: {
            self.viewModel.loadContent()
        })
        
    }
}

extension CountriesView {
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

extension CountriesView {
    
    struct CountryCell: View {
        
        
        let country: Country
        
        var body: some View {
            
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                               .fill(Color.black)
                ImageView(withURL: "https://source.unsplash.com/random")
                    .frame(width: 350, height: 250)
                VStack {
                    Text(country.name)
                        .font(.headline)
                        .colorInvert()
                    
                    Text(country.country)
                        .font(.caption)
                        .colorInvert()
                    Text(country.id)
                        .font(.caption2)
                        .colorInvert()
                }
                .padding(20)
                .multilineTextAlignment(.center)
            }
            
        }
    }
}




#if DEBUG
// MARK: - Preview

struct CountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView(viewModel: .init(container: TempraryCountriesContainer(authToken: AuthToken(value: "temp-8823007966"))))
    }
}

#endif


