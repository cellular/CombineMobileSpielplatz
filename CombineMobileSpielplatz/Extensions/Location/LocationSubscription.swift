//
//  Subscriptions+CLLocation.swift
//  CombineSpielplatz
//
//  Created by Dimitri Brukakis on 24.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

protocol LocationSubscriptionDelegate: class {
    func startLocationUpdate()
    func stopLocationUpdate()
}

protocol LocationSubscriptionProtocol: class {
    func sendLocation(location: CLLocation)
    func sendError(error: Error)
}

public final class LocationSubscription<S: Subscriber>: NSObject, CLLocationManagerDelegate, LocationSubscriptionProtocol,
                                                        Subscription where S.Input == CLLocation, S.Failure == LocationPublisher.Failure {
    
    private var delegate: LocationSubscriptionDelegate?
    private var subscriber: S?
    private var remainingDemand: Int = -1
    
    init(subscriber: S, delegate: LocationSubscriptionDelegate) {
        self.subscriber = subscriber
        self.delegate = delegate
    }
    
    public func request(_ demand: Subscribers.Demand) {
        // Request
        print("Request: \(demand)")
        if let max = demand.max {
            self.remainingDemand = max
        }
        delegate?.startLocationUpdate()
    }
    
    public func cancel() {
        // Cancel
        print("Cancel")
        delegate?.stopLocationUpdate()
    }
    
    // MARK: - LocationSubscriptionDelegate
    public func sendLocation(location: CLLocation) {
        _ = subscriber?.receive(location)
    }
    
    public func sendError(error: Error) {
        _ = subscriber?.receive(completion: .failure(.unknown))
    }
}
