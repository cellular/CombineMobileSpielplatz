//: [Previous](@previous)

import Foundation
import Combine

class SomeClass {
    var value: String? {
        didSet { print ("\(String(describing: value))")}
    }
}
var some = SomeClass()

var subscribers = Set<AnyCancellable>()
Just("Hello").assign(to: \.value, on: some).store(in: &subscribers)

//: [Next](@next)
