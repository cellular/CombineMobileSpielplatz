//
//  FirstViewController.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 31.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import UIKit
import Combine

class FirstViewController: UIViewController {

    // MARK: - Combine
    private var subscribers = Set<AnyCancellable>()
    private weak var subscriber: AnyCancellable?

    
    // MARK: - Output text view
    @IBOutlet private weak var textView: UITextView?

    // MARK: - Resource provider
    
    @IBOutlet private weak var userTextField: UITextField?
    
    
    // ---------------------------------------------------------------------
    // MARK: - Resourcce provider
    
    @IBAction func onCombineUser(_ sender: Any) {
        subscriber?.cancel()
        subscriber = nil
        
        guard let user = userTextField?.text else { return }
        textView?.text = ""
        
        ResourceProvider(resource: user, withExtension: "json")
            .publisher
            .decode(type: User.self, decoder: JSONDecoder())
            // .print()
            // .replaceError(with: User(email: "nobody@nowhere.com", name: "Nobody Knows"))
            .sink(
                receiveCompletion: { (error) in self.textView?.text.append("Received error: \(error)") },
                receiveValue: { (user) in self.textView?.text.append("\(user.name) => \(user.email)") }
            )
            .store(in: &subscribers)
    }
    
    @IBAction func onCombineAllUsers(_ sender: Any) {

        textView?.text = ""
        
        ["user1", "user2", "user3"].publisher
            .setFailureType(to: ResourceProvider.ResourcePublisher.Failure.self)
            .flatMap { (resource) in
                    return ResourceProvider(resource: resource, withExtension: "json").publisher
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .replaceError(with: User(email: "nobody@nowhere.com", name: "Nobody Knows"))
            .sink(receiveCompletion: { (error) in self.textView?.text.append("Error: \(error)") },
                  receiveValue: { (user) in
                    self.textView?.text.append("Found: \(user.email) -> \(user.name)\n")
                })
            .store(in: &subscribers)
    }
    // ---------------------------------------------------------------------

    
    
    
    // ---------------------------------------------------------------------
    // MARK: - Slider & Progress w/ PassThroughSubject
    
    let sliderPassThroughSubject = PassthroughSubject<Float, Never>()
    
    @IBOutlet private weak var slider: UISlider? {
        didSet {
            slider?.minimumValue = 0
            slider?.maximumValue = 50000
            slider?.value = 0
        }
    }
    
    @IBOutlet private weak var sliderProgress: UIProgressView? {
        didSet {
            sliderProgress?.progress = 0
        }
    }
    
    @IBAction func onSliderChangeValue(_ slider: UISlider) {
        sliderPassThroughSubject.send(slider.value)
    }
    
    private func setupSliderProgress() {
        sliderPassThroughSubject
            .map {
                guard let slider = self.slider else { return nil }
                return Float((1 / slider.maximumValue) * $0)
            }
            .replaceNil(with: 0)
            .assign(to: \.progress, on: sliderProgress!)
            .store(in: &subscribers)
        
        sliderPassThroughSubject
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .map { "Neuer wert: \($0)" }
            .sink { (wert) in
                self.textView?.text = wert
            }.store(in: &subscribers)
    }
    // ---------------------------------------------------------------------
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSliderProgress()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
