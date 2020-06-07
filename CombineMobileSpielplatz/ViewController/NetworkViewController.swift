//
//  NetworkViewController.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 07.06.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import UIKit
import Combine

class NetworkViewController: UIViewController {

    // MARK: - Combine
    
    var networkPublisher: AnyCancellable?
    var subscribers = Set<AnyCancellable>()
    
    @Published var searchBarText = ""
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar?
    @IBOutlet private weak var textView: UITextView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar?.delegate = self
        
        $searchBarText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .filter { $0.count > 2 }
            .setFailureType(to: URLSession.DataTaskPublisher.Failure.self)
            .flatMap { searchTerm in
                return WeatherProvider().dataTaskPublisher(for: searchTerm)
            }
            .map(\.data)
            .decode(type: WeatherResult.self, decoder: JSONDecoder())
            .map { weather -> String in
                "Weather: \(weather.description)"
            }
            .sink(receiveCompletion: { error in
                    // Completion
                    print("Completion \(error)")
                }, receiveValue: { result in
                    print(result)
                    DispatchQueue.main.async {
                        self.textView?.text = result
                    }
                }
        ).store(in: &subscribers)
    }
}

extension NetworkViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarText = searchText
    }
}
