import UIKit
import Combine


Just("Hello, playground")
    .sink(
    receiveCompletion: { error in print ("Done \(error)") },
    receiveValue: { print($0) }
)


//["Hallo", "welcome", "to", "combine"]
//    .publisher
//    .reduce("", { (result, value) -> String in
//        "\(result) \(value)"
//    })
//    .last()
//    .sink(
//        receiveCompletion: { error in print("\(error)")},
//        receiveValue: { print($0) }
//    )
