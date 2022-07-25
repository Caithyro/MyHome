//
//  RollerShutter.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 22.07.2022.
//

import Foundation

class RollerShutter: Device {
    
    init(id: Int,
         deviceName: String,
         position: Int,
         productType: ProductType) {
        
        super.init(id: id,
                   deviceName: deviceName,
                   intensity: nil,
                   mode: nil,
                   productType: productType,
                   position: position,
                   temperature: nil)
        self.id = id
        self.deviceName = deviceName
        self.position = position
        self.productType = productType
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
