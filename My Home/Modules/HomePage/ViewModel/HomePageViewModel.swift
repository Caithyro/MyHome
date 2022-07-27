//
//  HomePageViewModel.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import Foundation

class HomePageViewModel {
    
    var devicesArray: [Device] = []
    var lightsArray: [Light] = []
    var heatersArray: [Heater] = []
    var rollerShuttersArray: [RollerShutter] = []
    
    private let loadingService = LoadingService()
    
    func loadData(completion: @escaping(() -> ())) {
        
        loadingService.fetchData(completion: { devices in
            self.devicesArray = devices
            DispatchQueue.main.async {
                completion()
            }
        })
    }
}
