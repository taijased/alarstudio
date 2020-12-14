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
                        viewModel.loadMore(country)
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
            

            VStack(alignment: .leading)  {
                ImageView(withURL: country.defaultImageURL, size: CGSize(width: 350, height: 250))
             
                VStack(alignment: .leading) {
                    Text(country.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(country.country)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    Text(country.id)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)
             
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


