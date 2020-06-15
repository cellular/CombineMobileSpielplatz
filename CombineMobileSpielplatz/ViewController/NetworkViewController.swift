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
        
        setupCombine()
    }


    
    private func setupCombine() {
        $searchBarText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .filter { $0.count > 2 }
            .setFailureType(to: URLSession.DataTaskPublisher.Failure.self)
            .flatMap({ searchTerm in
                return WeatherProvider().dataTaskPublisher(for: searchTerm)
            })
            .mapError({ $0 as Error })
            .flatMap({ result -> AnyPublisher<WeatherResult, Error> in
                guard let urlResponse = result.response as? HTTPURLResponse,
                    (200...299).contains(urlResponse.statusCode) else {
                        return Just(result.data)
                            .decode(type: WeatherError.self, decoder: JSONDecoder())
                            .tryMap({ errorModel in throw errorModel })
                            .eraseToAnyPublisher()
                }
                return Just(result.data)
                    .decode(type: WeatherResult.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
            })
            .map({ weather -> String in
                "Weather: \(weather.description)"
            })
            .receive(on: DispatchQueue.main, options: .none)
            .sink(receiveCompletion: { error in self.textView?.text = "Completion with error: \(String(describing: error))" },
                  receiveValue: { weather in self.textView?.text = weather }
            ).store(in: &subscribers)
    }
    
    
    private func setupCombine1() {
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
