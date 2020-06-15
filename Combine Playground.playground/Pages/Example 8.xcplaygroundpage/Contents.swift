//: [Previous](@previous)

import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class CoronaItem: Decodable {
    var Country: String
    var CountryCode: String
    var Province: String
    var CityCode: String
    var Confirmed: Int
    var Recovered: Int
    var Deaths: Int
    var Active: Int
    var Date: String
    
    var description: String {
        "\(Country) confirmed=\(Confirmed) recovered=\(Recovered) active=\(Active) deaths=\(Deaths)"
    }
}

var subscribers = Set<AnyCancellable>()
if let url = URL(string: "https://api.covid19api.com/dayone/country/germany") {
    
    URLSession.shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: [CoronaItem].self, decoder: JSONDecoder())
        .sink(receiveCompletion: { error in print(error) },
              receiveValue: { result in
                result.forEach { (item) in
                    print(item.description)
                }
        })
        .store(in: &subscribers)
}


//: [Next](@next)
