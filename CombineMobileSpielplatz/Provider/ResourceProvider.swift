//
//  UserProvider.swift
//  CombineSpielplatz
//
//  Created by Dimitri Brukakis on 22.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import Combine

public final class ResourceProvider {
    
    let resource: String
    let ext: String
    
    init(resource: String, withExtension ext: String) {
        self.resource = resource
        self.ext = ext
    }

    var publisher: ResourcePublisher {
        return ResourcePublisher(resource: resource, withExtension: ext)
    }

    public struct ResourcePublisher: Publisher {
        public enum ResourceError: Error {
            case notFound
        }
        /// The kind of values published by this publisher.
        public typealias Output = Data

        /// The kind of errors this publisher might publish.
        ///
        /// Use `Never` if this `Publisher` does not publish errors.
        public typealias Failure = ResourcePublisher.ResourceError
        
        let resource: String
        let ext: String
        init(resource: String, withExtension ext: String) {
            self.resource = resource
            self.ext = ext
        }
        
        /// This function is called to attach the specified `Subscriber` to this `Publisher` by `subscribe(_:)`
        ///
        /// - SeeAlso: `subscribe(_:)`
        /// - Parameters:
        ///     - subscriber: The subscriber to attach to this `Publisher`.
        ///                   once attached it can begin to receive values.
        public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == ResourcePublisher.Failure, S.Input == ResourceProvider.ResourcePublisher.Output {
            
            guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
                subscriber.receive(completion: .failure(.notFound))
                return
            }
            do {
                let data = try Data(contentsOf: url)
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            } catch {
                subscriber.receive(completion: .failure(.notFound))
            }
        }
    }
    
}
