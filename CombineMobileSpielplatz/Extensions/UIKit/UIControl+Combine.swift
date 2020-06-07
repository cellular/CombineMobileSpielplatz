//
//  UIControl+Combine.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 31.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import UIKit
import Combine


public class UIControlTarget {
    let control: UIControl
    
    fileprivate var subject = PassthroughSubject<Void, Never>()
    
    init(_ control: UIControl) {
        self.control = control
        self.control.addTarget(self, action: #selector(onTouch(_:)), for: .touchUpInside)
    }
    
    @objc public func onTouch(_ sender: Any) {
        subject.send()
    }
    var publisher: PassthroughSubject<Void, Never> {
        return subject
    }
    
    deinit {
        print("Das wars")
    }
}

