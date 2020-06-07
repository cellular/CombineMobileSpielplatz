//
//  SimpleArray.swift
//  CombineSpielplatz
//
//  Created by Dimitri Brukakis on 22.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import Combine

final class SimpleInt32ValueProvider {
    
    let from: Int32
    let to: Int32
    
    init(from: Int32, to: Int32) {
        self.from = from
        self.to = to
    }
    
    var publisher: Publishers.Sequence<Array<Int32>, Never> {
        let range = [from...to]
        let array = range.flatMap { $0 }
        return array.publisher
    }
}
