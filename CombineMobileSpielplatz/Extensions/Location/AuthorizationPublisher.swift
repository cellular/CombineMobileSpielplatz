//
//  AuthorizationPublisher.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 07.06.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

public final class AuthorizationPublisher: NSObject {
    
    public enum AuthorizationType {
        case always
        case whenInUse
    }
    
    private var authorizationSubscription: AuthorizationSubscriptionProtocol?
    
    private let locationManager: CLLocationManager
    private let type: AuthorizationPublisher.AuthorizationType
    
    init(locationManager: CLLocationManager, type: AuthorizationPublisher.AuthorizationType) {
        self.locationManager = locationManager
        self.type = type
    }
}

extension AuthorizationPublisher: Publisher {
    public typealias Output = CLAuthorizationStatus
    public typealias Failure = Never

    public func receive<S>(subscriber: S) where S : Subscriber, AuthorizationPublisher.Failure == S.Failure, AuthorizationPublisher.Output == S.Input {
        
        let subscription = AuthorizationSubscription(subscriber: subscriber, type: self.type, delegate: self)
        subscriber.receive(subscription: subscription)
        authorizationSubscription = subscription
    }
}

extension AuthorizationPublisher: AuthorizationSubscriptionDelegate {
    func requestAuthorization(type: AuthorizationPublisher.AuthorizationType) {
        locationManager.delegate = self
        switch type {
        case .always: locationManager.requestAlwaysAuthorization()
        case .whenInUse: locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension AuthorizationPublisher: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationSubscription?.sendStatus(status: status)
    }
}
