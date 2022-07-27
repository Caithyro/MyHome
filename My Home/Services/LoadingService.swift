//
//  LoadingService.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 27.07.2022.
//

import Foundation

class LoadingService {
    
    private let url = URL(string: "http://storage42.com/modulotest/data.json")
    
    func fetchData(completion: @escaping(([Device]) -> ())) {
        
        var devicesArray: [Device] = []
        let task = URLSession.shared.dataTask(with: url!) {(data,
                                                            response,
                                                            error) in
            
            guard let data = data else { return }
            devicesArray.removeAll()
            var indexForAppend = 0
            let jsonDecoder = JSONDecoder()
            let decodedData = try? jsonDecoder.decode(ResponceData.self,
                                                      from: data.self)
            for _ in decodedData!.devices {
                devicesArray.append(decodedData!.devices[indexForAppend])
                indexForAppend += 1
            }
            completion(devicesArray)
            indexForAppend = 0
            
        }
        task.resume()
    }
}
