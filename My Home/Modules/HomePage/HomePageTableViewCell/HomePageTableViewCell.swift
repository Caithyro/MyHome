//
//  HomePageTableViewCell.swift
//  My Home
//
//  Created by Дмитрий Куприенко on 23.07.2022.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {
    
    var deviceItem: Device?
    
    var homePageViewModel: HomePageViewModel!
    private var textForLights = String()
    private var textForHeater = String()
    private var textForRollerShutter = String()
    private var deviceImageView = UIImageView()
    private var deviceImage = UIImage()
    private var deviceLabel = UILabel()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        
        createTextAndAssingImage()
        switch deviceItem?.productType {
        case .light:
            configureLightCell()
        case .heater:
            configureHeaterCell()
        case .rollerShutter:
            configureRollerShutterCell()
        case .none:
            print(NSLocalizedString("l.errorUnknownDeviceString", comment: ""))
        }
        
    }
    
    //MARK: - Private
    
    private func createImageView() {
        
        let defaultSpacing = 8
        let defaultSize = 30
        self.addSubview(deviceImageView)
        self.deviceImageView.translatesAutoresizingMaskIntoConstraints = false
        self.deviceImageView.heightAnchor.constraint(equalToConstant: CGFloat(defaultSize)).isActive = true
        self.deviceImageView.widthAnchor.constraint(equalToConstant: CGFloat(defaultSize)).isActive = true
        self.deviceImageView.topAnchor.constraint(equalTo: self.topAnchor,
                                                  constant: CGFloat(defaultSpacing)).isActive = true
        self.deviceImageView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                   constant: CGFloat(defaultSpacing)).isActive = true
    }
    
    private func createDeviceLabel() {
        
        let defaultSpacing = 8
        let fontSize = 14
        self.addSubview(deviceLabel)
        self.deviceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.deviceLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: CGFloat(defaultSpacing)).isActive = true
        self.deviceLabel.leftAnchor.constraint(equalTo: deviceImageView.rightAnchor,
                                               constant: CGFloat(defaultSpacing)).isActive = true
        self.deviceLabel.font = .systemFont(ofSize: CGFloat(fontSize))
    }
    
    private func configureLightCell() {
        
        createImageView()
        createDeviceLabel()
        self.deviceImageView.image = deviceImage
        self.deviceLabel.text = textForLights
        self.deviceLabel.numberOfLines = 0
        let lightDevice = Light(id: deviceItem!.id,
                                deviceName: deviceItem!.deviceName,
                                intensity: deviceItem!.intensity ?? 0,
                                mode: deviceItem!.mode ?? NSLocalizedString("l.deviceModeOffString", comment: ""),
                                productType: deviceItem!.productType)
        homePageViewModel.lightsArray.append(lightDevice)
    }
    
    private func configureHeaterCell() {
        
        createImageView()
        createDeviceLabel()
        self.deviceImageView.image = deviceImage
        self.deviceLabel.text = textForHeater
        self.deviceLabel.numberOfLines = 0
        let heaterDevice = Heater(id: deviceItem!.id,
                                  deviceName: deviceItem!.deviceName,
                                  temperature: deviceItem!.temperature ?? 0,
                                  mode: deviceItem!.mode ?? NSLocalizedString("l.deviceModeOffString", comment: ""),
                                  productType: deviceItem!.productType)
        homePageViewModel.heatersArray.append(heaterDevice)
    }
    
    private func configureRollerShutterCell() {
        
        createImageView()
        createDeviceLabel()
        self.deviceImageView.image = deviceImage
        self.deviceLabel.text = textForRollerShutter
        self.deviceLabel.numberOfLines = 0
        let rollerShutterDevice = RollerShutter(id: deviceItem!.id,
                                                deviceName: deviceItem!.deviceName,
                                                position: deviceItem!.position ?? 0,
                                                productType: deviceItem!.productType)
        homePageViewModel.rollerShuttersArray.append(rollerShutterDevice)
    }
    
    private func createTextAndAssingImage() {
        
        switch deviceItem!.productType {
        case  .light:
            if deviceItem!.mode == deviceModeOffString {
                textForLights = deviceItem!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                 comment: "") + " " + NSLocalizedString("l.deviceModeOffString", comment: "")
                deviceImage = UIImage(named: "DeviceLightOffIcon")!
            } else {
                let textForLightsFirstPart = deviceItem!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                              comment: "") + " " + NSLocalizedString("l.deviceModeOnString", comment: "")
                let textForLightsSecondPart = NSLocalizedString("l.atString",
                                                                comment: "") + " " + String(describing: (deviceItem!.intensity
                                                                                                         ?? 0)) + percentString
                textForLights = textForLightsFirstPart + " " + textForLightsSecondPart
                deviceImage = UIImage(named: "DeviceLightOnIcon")!
            }
        case .heater:
            if deviceItem!.mode == deviceModeOffString {
                textForHeater = deviceItem!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                 comment: "") + " " + NSLocalizedString("l.deviceModeOffString", comment: "")
                deviceImage = UIImage(named: "DeviceHeaterOffIcon")!
            } else {
                let textForHeaterFirstPart = deviceItem!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                              comment: "") + " " + NSLocalizedString("l.deviceModeOnString", comment: "")
                let textForHeaterSecondPart = NSLocalizedString("l.atString", comment: "") + " " + String(describing: (deviceItem!.temperature
                                                                                                                       ?? 0)) + celsiusDegreeString
                textForHeater = textForHeaterFirstPart + " " + textForHeaterSecondPart
                deviceImage = UIImage(named: "DeviceHeaterOnIcon")!
            }
        case .rollerShutter:
            if deviceItem!.position == 0 {
                textForRollerShutter = deviceItem!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                        comment: "") + " " + NSLocalizedString("l.deviceStateClosedString", comment: "")
                deviceImage = UIImage(named: "DeviceRollerShutterClosedIcon")!
            } else {
                let textForRollerShutterFirstPart = deviceItem!.deviceName + " " + NSLocalizedString("l.isString",
                                                                                                     comment: "") + " " + NSLocalizedString("l.deviceStateOpenedString", comment: "")
                let textForRollerShutterSecondPart = NSLocalizedString("l.atString", comment: "") + " " + String(describing: deviceItem!.position
                                                                                                                 ?? 0) + percentString
                textForRollerShutter = textForRollerShutterFirstPart + " " + textForRollerShutterSecondPart
                deviceImage = UIImage(named: "DeviceRollerShutterOpenIcon")!
            }
        }
    }
}
