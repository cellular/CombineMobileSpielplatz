//: [Previous](@previous)

import Foundation
import Combine

import PlaygroundSupport
 
PlaygroundPage.current.needsIndefiniteExecution = true


class Example7 {
    var subscribers = Set<AnyCancellable>()
    
    @Published var searchBarText = ""

    init() {
        $searchBarText
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .filter { $0.count > 5 }
            .sink(receiveCompletion: { (_) in
                print("Completed")
            }, receiveValue: { (value) in
                print("Search for: \(value)")
            }).store(in: &subscribers)
    }
    
    func updateValue(value: String) {
        searchBarText = value
    }
}

let example7 = Example7()

example7.updateValue(value: "Ham")
example7.updateValue(value: "Hambur")
//: [Next](@next)
