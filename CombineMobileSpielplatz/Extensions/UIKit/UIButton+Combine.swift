//
//  UIButton+Combine.swift
//  CombineMobileSpielplatz
//
//  Created by Dimitri Brukakis on 31.05.20.
//  Copyright © 2020 Dimitri Brukakis. All rights reserved.
//

import Foundation
import Combine
import UIKit

extension UIButton {
    
    public var target: UIControlTarget {
        let target = UIControlTarget(self)
        return target
    }
}
