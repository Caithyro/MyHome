//
//  Light.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 22.07.2022.
//

import Foundation

class Light: Device {
    
    init(id: Int, deviceName: String, intensity: Int,
         mode: String, productType: ProductType) {
        
        super.init(id: id, deviceName: deviceName, intensity: intensity,
                   mode: mode, productType: productType, position: nil,
                   temperature: nil)
        self.id = id
        self.deviceName = deviceName
        self.intensity = intensity
        self.mode = mode
        self.productType = productType
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
