import Foundation

class Address: Codable {
    
    let city: String
    let postalCode: Int
    let street, streetCode, country: String
    
    init(city: String, postalCode: Int, street: String,
         streetCode: String, country: String) {
        self.city = city
        self.postalCode = postalCode
        self.street = street
        self.streetCode = streetCode
        self.country = country
    }
}
