//: [Previous](@previous)

import Foundation
import Combine

enum APIError: Error {
    case negativeValue
}

let array = [1,2,4,5,7,3,2,5,-1,9,23,12,75,23,34,65,76]
array.publisher
 //    .setFailureType(to: APIError.self)
 //    .tryFilter {
 //        guard $0 >= 0 else { throw APIError.negativeValue }
 //        return true
 //    }
 //    .replaceError(with: 1000)
    .map { "\($0)" }
    .delay(for: 1, scheduler: DispatchQueue.main)
    .sink(receiveCompletion: { (error) in print("Error: \(error)") },
          receiveValue: { print("Value: \($0)") }
    )

//: [Next](@next)
