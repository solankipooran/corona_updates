//
//  LocationStorage.swift
//  CoronaUpdates
//
//  Created by POORAN SUTHAR on 18/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationObserver: class {
    func locationAdded()
}

class LocationsStorage  {
    
    static let shared = LocationsStorage()
    
    private init() {
        
    }
    
    var observers: [LocationObserver] = []
    
    var locations: [Location] = [] {
        didSet {
            observers.forEach { $0.locationAdded() }
        }
    }
    
    func saveLocationOnDisk(_ location: Location) {
        locations.append(location)
    }
    
    func saveCLLocationToDisk(_ clLocation: CLLocation) {
        let currentDate = Date()
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let location = Location(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
                self.saveLocationOnDisk(location)
            }
        }
    }
    
    func addObserver(obserer: LocationObserver) {
        observers.append(obserer)
    }
    
    func removeObserver(observer: LocationObserver) {
        observers.removeAll { $0 === observer}
    }
    
}

