import Foundation

class ResponceData: Codable {
    
    let devices: [Device]
    let user: User
    
    init(devices: [Device], user: User) {
        
        self.devices = devices
        self.user = user
    }
}
