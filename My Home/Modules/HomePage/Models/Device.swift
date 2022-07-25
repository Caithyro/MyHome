import Foundation

class Device: Codable {
    
    var id: Int
    var deviceName: String
    var intensity: Int?
    var mode: String?
    var productType: ProductType
    var position, temperature: Int?
    
    init(id: Int, deviceName: String, intensity: Int?, mode: String?,
         productType: ProductType, position: Int?, temperature: Int?) {
        self.id = id
        self.deviceName = deviceName
        self.intensity = intensity
        self.mode = mode
        self.productType = productType
        self.position = position
        self.temperature = temperature
    }
}
