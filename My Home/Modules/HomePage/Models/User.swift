import Foundation

class User: Codable {
    
    let firstName, lastName: String
    let address: Address
    let birthDate: Int
    
    init(firstName: String, lastName: String,
         address: Address, birthDate: Int) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.birthDate = birthDate
    }
}
