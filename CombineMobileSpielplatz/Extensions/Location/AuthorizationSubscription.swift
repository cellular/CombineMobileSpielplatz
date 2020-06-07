//
//  AuthorizationSubscription.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 07.06.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

protocol AuthorizationSubscriptionDelegate: class {
    func requestAuthorization(type: AuthorizationPublisher.AuthorizationType)
    
}

protocol AuthorizationSubscriptionProtocol: class {
    func sendStatus(status: CLAuthorizationStatus)
}

public final class AuthorizationSubscription<S: Subscriber>: NSObject, CLLocationManagerDelegate, AuthorizationSubscriptionProtocol, Subscription where S.Input == CLAuthorizationStatus, S.Failure == AuthorizationPublisher.Failure {
    
    private var delegate: AuthorizationSubscriptionDelegate?
    private var subscriber: S?
    private var remainingDemand: Int = -1

    private var type: AuthorizationPublisher.AuthorizationType
    
    init(subscriber: S, type: AuthorizationPublisher.AuthorizationType, delegate: AuthorizationSubscriptionDelegate) {
        self.subscriber = subscriber
        self.delegate = delegate
        self.type = type
    }
  
    
    public func request(_ demand: Subscribers.Demand) {
        delegate?.requestAuthorization(type: type)
    }
    
    public func cancel() {
        // Cancel
    }
    
    // MARK: - AuthorizationSubscriptionDelegate
    public func sendStatus(status: CLAuthorizationStatus) {
        _ = subscriber?.receive(status)
    }
}
