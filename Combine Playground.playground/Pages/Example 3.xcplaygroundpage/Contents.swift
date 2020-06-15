//: [Previous](@previous)

import Foundation
import Combine


[1,2,3,4,5,6,7]
    .publisher
    .map { "-- \($0) --"}
    .sink (receiveValue: { print("Received \($0)") })


//: [Next](@next)
