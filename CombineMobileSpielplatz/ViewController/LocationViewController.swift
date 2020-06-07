//
//  ViewController.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 25.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

class LocationViewController: UIViewController {

    var locationSubscriber: AnyCancellable?
    
    var subscriber = Set<AnyCancellable>()
    
    // MARK: - Outlets
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var statusTextField: UITextField!
    
    
    let model = LocationViewController.Model()
    
    
    // MARK: - Actions
    @IBAction func onLocationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            startLocationUpdates()
        } else {
            stopLocationUpdates()
        }
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CLLocationManager
            .requestAuthorization(type: .whenInUse)
            .map { status -> String in
                switch status {
                case .authorizedAlways: return "Always"
                case .authorizedWhenInUse: return "When in use"
                case .denied: return "Denied"
                default: return "Unknown"
                }
            }
            .assign(to: \.text, on: statusTextField)
            .store(in: &subscriber)
    }

    
    // MARK: - Location
    
    private func startLocationUpdates() {
        locationSubscriber = CLLocationManager.publisher()
            .map { "You are here: \($0.coordinate.latitude) \($0.coordinate.longitude)" }
            .sink(receiveCompletion: { (error) in
                print("Completed: \(error)")
                self.locationSwitch.isOn = false
            }, receiveValue: { (location) in
                print("Location: \(location)")
                self.textField.text.append("\(location)\n")
            })
    }
    
    private func stopLocationUpdates() {
        locationSubscriber?.cancel()
        locationSubscriber = nil
    }

}


extension LocationViewController {
    class Model {
        var lat: Double = 0
        var lon: Double = 0
    }
}
