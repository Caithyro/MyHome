//
//  Heater.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 22.07.2022.
//

import Foundation

class Heater: Device {
    
    init(id: Int, deviceName: String, temperature: Int,
         mode: String, productType: ProductType) {
        
        super.init(id: id, deviceName: deviceName, intensity: nil,
                   mode: mode, productType: productType, position: nil,
                   temperature: temperature)
        self.id = id
        self.deviceName = deviceName
        self.mode = mode
        self.intensity = intensity
        self.productType = productType
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
