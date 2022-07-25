//
//  ControlPageViewModel.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import Foundation

class ControlPageViewModel {
    
    static let shared = ControlPageViewModel()
    
    var lightsArray: [Light] = []
    var heatersArray: [Heater] = []
    var rollerShuttersArray: [RollerShutter] = []
    var targetDeviceID = Int()
    var targetDeviceType = String()
}
