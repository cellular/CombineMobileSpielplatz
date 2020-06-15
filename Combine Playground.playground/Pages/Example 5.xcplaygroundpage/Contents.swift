//: [Previous](@previous)

import Foundation
import Combine

var subscribers = Set<AnyCancellable>()

let passThrough = PassthroughSubject<Int,Never>()

passThrough
    .filter({ $0 > 100 })
    .map { "Aktueller Preis: \($0)" }
    .sink(receiveCompletion: { _ in print("Beendet") },
          receiveValue: { value in print (value) })
    .store(in: &subscribers)

for i in 1...200 {
    passThrough.send(i)
}

passThrough.send(completion: .finished)

//: [Next](@next)
