//
//  Weather.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 07.06.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation


struct WeatherResult: Decodable {
    var coord: Coord?
    var weather: [Weather]?
    var main: Main?
    var visibilty: Int?
    var clouds: Clouds?
    var name: String?
    var cod: Int?
    var id: Int?
    
    var description: String {
        var result = "\(name ?? "Unknown")\n"
        if let weather = weather {
            weather.forEach {
                result.append("\($0.main ?? "") ->  \($0.description ?? "")\n")
            }
        }
        let temp = Measurement(value: main?.temp ?? 0.0, unit: UnitTemperature.fahrenheit)
        let formatter = MeasurementFormatter()
        result.append("Temp: \(formatter.string(from: temp))")
        return result
    }
}

struct Coord: Decodable {
    var lat: Double?
    var lon: Double?
}

struct Weather: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Main: Decodable {
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var preasure: Int?
    var humidity: Int?
}

struct Clouds: Decodable {
    var all: Int?
}

