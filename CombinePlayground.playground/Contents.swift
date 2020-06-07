import UIKit
import Combine


Just("Hello, playground").sink(receiveValue: { print($0) }, receiveCompletion: { print ("Done") })
