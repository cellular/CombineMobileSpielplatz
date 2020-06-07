//
//  CLLocationManager+Combine.swift
//  CombineSpielplatz
//
//  Created by Dimitri Brukakis on 24.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

/// Enhance the location manage with a publisher to be able to use
/// it with Combine.
extension CLLocationManager {

    func publisher() -> AnyPublisher<CLLocation, LocationPublisher.LocationError> {
        let publisher = LocationPublisher(locationManager: self)
        return publisher.eraseToAnyPublisher()
    }
    
    static func publisher() -> AnyPublisher<CLLocation, LocationPublisher.LocationError> {
        let publisher = LocationPublisher(locationManager: CLLocationManager())
        return publisher.eraseToAnyPublisher()
    }
    
    static func requestAuthorization(type: AuthorizationPublisher.AuthorizationType) -> AnyPublisher<CLAuthorizationStatus, Never> {
        let publisher = AuthorizationPublisher(locationManager: CLLocationManager(), type: type)
        return publisher.eraseToAnyPublisher()
    }
}
