//
//  LocationPublisher.swift
//  CombineSpielplatz
//
//  Created by Dimitri Brukakis on 24.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

/// The LocationPublisher will send new location data to subscribed entities.
public final class LocationPublisher: NSObject {
    /// Something went wrong
    public enum LocationError: Error {
        case unknown
        case notAuthorized
        case restricted
    }

    private var locationSubscription: LocationSubscriptionProtocol?
    private let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
}

extension LocationPublisher: Publisher {
    public typealias Output = CLLocation
    public typealias Failure = LocationPublisher.LocationError
    
    public func receive<S>(subscriber: S) where S : Subscriber, LocationPublisher.Failure == S.Failure, LocationPublisher.Output == S.Input {
        let subscription = LocationSubscription(subscriber: subscriber, delegate: self)
        subscriber.receive(subscription: subscription)
        locationSubscription = subscription
    }
}

extension LocationPublisher: LocationSubscriptionDelegate {
    func startLocationUpdate() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationPublisher: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let subscription = locationSubscription, let location = locations.first else { return }
        subscription.sendLocation(location: location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubscription?.sendError(error: error)
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            locationSubscription?.sendError(error: LocationError.notAuthorized)
        case .restricted:
            locationSubscription?.sendError(error: LocationError.restricted)
        default:
            break
        }
    }
}



