//
//  HomePageViewModel.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import Foundation

class HomePageViewModel {
    
    static let shared = HomePageViewModel()
    
    var devicesArray: [Device] = []
    var lightsArray: [Light] = []
    var heatersArray: [Heater] = []
    var rollerShuttersArray: [RollerShutter] = []
    
    private let url = URL(string: "http://storage42.com/modulotest/data.json")
    
    func fetchData(completion: @escaping(() -> ())) {
        
        let task = URLSession.shared.dataTask(with: url!) {(data,
                                                            response,
                                                            error) in
            
            guard let data = data else { return }
            self.devicesArray.removeAll()
            var indexForAppend = 0
            let jsonDecoder = JSONDecoder()
            let decodedData = try? jsonDecoder.decode(ResponceData.self,
                                                      from: data.self)
            for _ in decodedData!.devices {
                self.devicesArray.append(decodedData!.devices[indexForAppend])
                indexForAppend += 1
            }
            indexForAppend = 0
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
}
