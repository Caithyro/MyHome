//
//  HomePageTableViewCell.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {
    
    var deviceItem = [Device]()
    
    private var homePageViewModel = HomePageViewModel.shared
    private var textForLights = String()
    private var textForHeater = String()
    private var textForRollerShutter = String()
    private var deviceImage = UIImage()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        
        createTextAndAssingImage()
        switch deviceItem.first?.productType {
        case .light:
            configureLightCell()
        case .heater:
            configureHeaterCell()
        case .rollerShutter:
            configureRollerShutterCell()
        default:
            print(errorUnknownDeviceString)
        }
        
    }
    
    //MARK: - Private
    
    private func configureLightCell() {
        
        self.imageView?.image = deviceImage
        self.textLabel?.text = textForLights
        self.textLabel?.numberOfLines = 0
        let lightDevice = Light(id: deviceItem.first?.id ?? 0,
                                deviceName: deviceItem.first?.deviceName ?? deviceUnknownString,
                                intensity: deviceItem.first?.intensity ?? 0,
                                mode: deviceItem.first?.mode ?? deviceModeOffString,
                                productType: deviceItem.first?.productType ?? .light)
        homePageViewModel.lightsArray.append(lightDevice)
        deviceItem.removeAll()
    }
    
    private func configureHeaterCell() {
        
        self.imageView?.image = deviceImage
        self.textLabel?.text = textForHeater
        self.textLabel?.numberOfLines = 0
        let heaterDevice = Heater(id: deviceItem.first?.id ?? 0,
                                  deviceName: deviceItem.first?.deviceName ?? deviceUnknownString,
                                  temperature: deviceItem.first?.temperature ?? 0,
                                  mode: deviceItem.first?.mode ?? deviceModeOffString,
                                  productType: deviceItem.first?.productType ?? .heater)
        homePageViewModel.heatersArray.append(heaterDevice)
        deviceItem.removeAll()
    }
    
    private func configureRollerShutterCell() {
        
        self.imageView?.image = deviceImage
        self.textLabel?.text = textForRollerShutter
        self.textLabel?.numberOfLines = 0
        let rollerShutterDevice = RollerShutter(id: deviceItem.first?.id ?? 0,
                                                deviceName: deviceItem.first?.deviceName ?? deviceUnknownString,
                                                position: deviceItem.first?.position ?? 0,
                                                productType: deviceItem.first?.productType ?? .rollerShutter)
        homePageViewModel.rollerShuttersArray.append(rollerShutterDevice)
        deviceItem.removeAll()
    }
    
    private func createTextAndAssingImage() {
        
        switch deviceItem.first?.productType {
        case  .light:
            if deviceItem.first!.mode == deviceModeOffString {
                textForLights = deviceItem.first!.deviceName + " " + isString + " " + deviceModeOffString
                deviceImage = UIImage(systemName: "lightbulb")!
            } else {
                let textForLightsFirstPart = deviceItem.first!.deviceName + " " + isString + " " + (deviceItem.first!.mode
                                                                                                   ?? deviceUnknownString)
                let textForLightsSecondPart = atString + " " + String(describing: (deviceItem.first!.intensity
                                                                                   ?? 0)) + percentString
                textForLights = textForLightsFirstPart + " " + textForLightsSecondPart
                deviceImage = UIImage(systemName: "lightbulb.fill")!
            }
        case .heater:
            if deviceItem.first!.mode == deviceModeOffString {
                textForHeater = deviceItem.first!.deviceName + " " + isString + " " + deviceModeOffString
                deviceImage = UIImage(systemName: "thermometer.snowflake")!
            } else {
                let textForHeaterFirstPart = deviceItem.first!.deviceName + " " + isString + " " + (deviceItem.first!.mode
                                                                                                   ?? deviceUnknownString)
                let textForHeaterSecondPart = atString + " " + String(describing: (deviceItem.first!.temperature
                                                                                   ?? 0)) + celsiusDegreeString
                textForHeater = textForHeaterFirstPart + " " + textForHeaterSecondPart
                deviceImage = UIImage(systemName: "thermometer.sun.fill")!
            }
        case .rollerShutter:
            if deviceItem.first!.position == 0 {
                textForRollerShutter = deviceItem.first!.deviceName + " " + isString + " " + deviceStateClosedString
                deviceImage = UIImage(systemName: "rectangle.tophalf.filled")!
            } else {
                let textForRollerShutterFirstPart = deviceItem.first!.deviceName + " " + isString + " " + deviceStateOpenedString
                let textForRollerShutterSecondPart = atString + " " + String(describing: deviceItem.first!.position
                                                                             ?? 0) + percentString
                textForRollerShutter = textForRollerShutterFirstPart + " " + textForRollerShutterSecondPart
                deviceImage = UIImage(systemName: "rectangle.tophalf.filled")!
            }
        default:
            print(errorUnknownDeviceString)
        }
    }
}
