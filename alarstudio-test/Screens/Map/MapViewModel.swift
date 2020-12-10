//
//  MapViewModel.swift
//  alarstudio-test
//
//  Created by Максим Спиридонов on 10.12.2020.
//


import Combine
import Foundation
import MapKit

final class MapViewModel: ObservableObject {
    
    let country: Country
    let onClose = PassthroughSubject<Void, Never>()
    let onFinish = PassthroughSubject<Void, Never>()
   
    @Published var coordinateRegion: MKCoordinateRegion
    
 
    
    init(container: CountriesContainerProtocol, country: Country) {
        self.country = country

        
        coordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: country.lat, longitude: country.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
      
        
    }
    
    
    func close() {
        onClose.send(())
    }
    
    deinit {
        onFinish.send(())
    }
}
