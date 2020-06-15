//
//  WeatherProvider.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 07.06.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import Combine

class WeatherProvider {
    
    let apitemplate = "https://api.openweathermap.org/data/2.5/weather?q=$$city$$&appid=ac333e0ef57a572bcd2b9d3dcc48627a"
    
    func dataTaskPublisher(for city: String) -> URLSession.DataTaskPublisher {
        guard let url = URL(string: apitemplate.replacingOccurrences(of: "$$city$$", with: city)) else {
            return URLSession.shared.dataTaskPublisher(for: URL(string: "https://server.not.found")!)
        }
        return URLSession.shared.dataTaskPublisher(for: url)
    }
}
